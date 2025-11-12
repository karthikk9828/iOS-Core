//
// StudentsAppSingleFile.swift
// iOS 15+
//

import UIKit
import Foundation
import CoreData
import Network
import ImageIO
import CryptoKit

// MARK: - Model

struct Student: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let avatarURL: URL
    let details: String?
    let updatedAt: Date
    var avatarDiskPath: String?
}

// MARK: - Network Monitor (offline / constrained)

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private(set) var isOnline: Bool = true
    private(set) var isConstrained: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isOnline = (path.status == .satisfied)
            self?.isConstrained = path.isConstrained
        }
        monitor.start(queue: queue)
    }
}

// MARK: - API Client

protocol APIClient {
    func fetchStudents() async throws -> [Student]
}

final class DefaultAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.allowsConstrainedNetworkAccess = true
        config.httpMaximumConnectionsPerHost = 6
        return URLSession(configuration: config)
    }()) {
        self.baseURL = baseURL
        self.session = session
    }

    func fetchStudents() async throws -> [Student] {
        // Replace "/students" with your endpoint path
        var req = URLRequest(url: baseURL.appendingPathComponent("/students"))
        req.httpMethod = "GET"
        let (data, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        // If your API schema differs, decode a DTO and map to Student
        var students = try decoder.decode([Student].self, from: data)
        if students.first?.updatedAt == nil {
            // Fallback if backend doesn't send dates
            let now = Date()
            students = students.map {
                Student(id: \$0.id, name: \$0.name, avatarURL: \$0.avatarURL, details: \$0.details, updatedAt: now, avatarDiskPath: \$0.avatarDiskPath)
            }
        }
        return students
    }
}

// MARK: - Core Data (programmatic model, no .xcdatamodeld required)

@objc(StudentEntity)
class StudentEntity: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var avatarURL: String
    @NSManaged var details: String?
    @NSManaged var updatedAt: Date
    @NSManaged var avatarDiskPath: String?
}

extension StudentEntity {
    func toModel() -> Student {
        Student(
            id: id,
            name: name,
            avatarURL: URL(string: avatarURL) ?? URL(string: "about:blank")!,
            details: details,
            updatedAt: updatedAt,
            avatarDiskPath: avatarDiskPath
        )
    }
    func apply(from model: Student) {
        id = model.id
        name = model.name
        avatarURL = model.avatarURL.absoluteString
        details = model.details
        updatedAt = model.updatedAt
        avatarDiskPath = model.avatarDiskPath
    }
}

final class CoreDataStudentsStore {
    private let container: NSPersistentContainer

    init() {
        let model = CoreDataStudentsStore.makeModel()
        container = NSPersistentContainer(name: "StudentsModel", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Core Data load error: \(error)") }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = "StudentEntity"
        entity.managedObjectClassName = NSStringFromClass(StudentEntity.self)

        let id = NSAttributeDescription()
        id.name = "id"; id.attributeType = .stringAttributeType; id.isOptional = false

        let name = NSAttributeDescription()
        name.name = "name"; name.attributeType = .stringAttributeType; name.isOptional = false

        let avatarURL = NSAttributeDescription()
        avatarURL.name = "avatarURL"; avatarURL.attributeType = .stringAttributeType; avatarURL.isOptional = false

        let details = NSAttributeDescription()
        details.name = "details"; details.attributeType = .stringAttributeType; details.isOptional = true

        let updatedAt = NSAttributeDescription()
        updatedAt.name = "updatedAt"; updatedAt.attributeType = .dateAttributeType; updatedAt.isOptional = false

        let avatarDiskPath = NSAttributeDescription()
        avatarDiskPath.name = "avatarDiskPath"; avatarDiskPath.attributeType = .stringAttributeType; avatarDiskPath.isOptional = true

        entity.properties = [id, name, avatarURL, details, updatedAt, avatarDiskPath]
        entity.uniquenessConstraints = [["id"]]
        model.entities = [entity]
        return model
    }

    func loadStudents() async -> [Student] {
        await container.viewContext.perform {
            let req = NSFetchRequest<StudentEntity>(entityName: "StudentEntity")
            req.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
            let entities = (try? self.container.viewContext.fetch(req)) ?? []
            return entities.map { \$0.toModel() }
        }
    }

    func save(students: [Student]) async {
        let ctx = container.newBackgroundContext()
        await ctx.perform {
            let ids = students.map { \$0.id }
            let fetch = NSFetchRequest<StudentEntity>(entityName: "StudentEntity")
            fetch.predicate = NSPredicate(format: "id IN %@", ids)
            let existing = (try? ctx.fetch(fetch)) ?? []
            var map = [String: StudentEntity](uniqueKeysWithValues: existing.map { (\$0.id, \$0) })
            for s in students {
                let entity = map[s.id] ?? StudentEntity(context: ctx)
                entity.apply(from: s)
                map[s.id] = entity
            }
            do { try ctx.save() } catch { print("Core Data save error: \(error)") }
        }
    }
}

// MARK: - Repository

protocol StudentsRepository {
    func studentsStream() -> AsyncStream<[Student]>
    func refresh() async throws
}

final class DefaultStudentsRepository: StudentsRepository {
    private let api: APIClient
    private let store: CoreDataStudentsStore

    init(api: APIClient, store: CoreDataStudentsStore) {
        self.api = api
        self.store = store
    }

    func studentsStream() -> AsyncStream<[Student]> {
        AsyncStream { continuation in
            Task {
                let cached = await store.loadStudents()
                continuation.yield(cached)
                do {
                    if NetworkMonitor.shared.isOnline {
                        let fresh = try await api.fetchStudents()
                        await store.save(students: fresh)
                        continuation.yield(fresh)
                    }
                } catch {
                    print("Network refresh error: \(error)")
                }
                continuation.finish()
            }
        }
    }

    func refresh() async throws {
        let fresh = try await api.fetchStudents()
        await store.save(students: fresh)
    }
}

// MARK: - Disk Cache

final class DiskCache {
    private let directory: URL
    private let ioQueue = DispatchQueue(label: "DiskCache.io", qos: .utility)
    private let fileManager = FileManager.default
    private let maxBytes: Int64

    init(name: String = "ImageCache", maxBytes: Int64 = 300 * 1024 * 1024) {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        directory = caches.appendingPathComponent(name, isDirectory: true)
        self.maxBytes = maxBytes
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        var rv = URLResourceValues()
        rv.isExcludedFromBackup = true
        try? directory.setResourceValues(rv)
    }

    private func path(for url: URL) -> URL {
        let name = Data(url.absoluteString.utf8).sha256Hex
        return directory.appendingPathComponent(name)
    }

    @discardableResult
    func write(data: Data, for url: URL) throws -> String {
        let fileURL = path(for: url)
        try data.write(to: fileURL, options: .atomic)
        updateModDate(fileURL)
        pruneIfNeededAsync()
        return fileURL.path
    }

    func read(url: URL) -> Data? {
        let fileURL = path(for: url)
        if let data = try? Data(contentsOf: fileURL) {
            updateModDate(fileURL)
            return data
        }
        return nil
    }

    func read(path: String) -> Data? {
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url) {
            updateModDate(url)
            return data
        }
        return nil
    }

    private func updateModDate(_ url: URL) {
        try? fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: url.path)
    }

    private func pruneIfNeededAsync() {
        ioQueue.async { [directory, maxBytes] in
            let fm = FileManager.default
            guard let files = try? fm.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey], options: [.skipsHiddenFiles]) else { return }
            var items: [(URL, Date, Int64)] = []
            var total: Int64 = 0
            for f in files {
                let rv = try? f.resourceValues(forKeys: [.contentModificationDateKey, .fileSizeKey])
                let size = Int64(rv?.fileSize ?? 0)
                total += size
                items.append((f, rv?.contentModificationDate ?? Date(), size))
            }
            guard total > maxBytes else { return }
            items.sort { \$0.1 < \$1.1 } // oldest first
            var current = total
            for (url, _, size) in items {
                if current <= maxBytes { break }
                try? fm.removeItem(at: url)
                current -= size
            }
        }
    }
}

private extension Data {
    var sha256Hex: String {
        let digest = SHA256.hash(data: self)
        return digest.map { String(format: "%02x", \$0) }.joined()
    }
}

// MARK: - Downsampling

enum ImageDownsampler {
    static func downsample(data: Data, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let maxDim = max(pointSize.width, pointSize.height) * scale
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: Int(maxDim),
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - Async Semaphore (concurrency cap)

actor AsyncSemaphore {
    private var value: Int
    private var waiters: [CheckedContinuation<Void, Never>] = []
    init(value: Int) { self.value = value }
    func wait() async {
        if value > 0 {
            value -= 1
            return
        }
        await withCheckedContinuation { cont in
            waiters.append(cont)
        }
    }
    func signal() {
        if waiters.isEmpty {
            value += 1
        } else {
            let cont = waiters.removeFirst()
            cont.resume()
        }
    }
}

// MARK: - Image Loader (concurrent, de-duplicated, capped)

actor ImageLoader {
    static let shared = ImageLoader()
    private let memory = NSCache<NSURL, UIImage>()
    private var inflight: [URL: Task<UIImage, Error>] = [:]
    private let disk = DiskCache()
    private let session: URLSession
    private let semaphore = AsyncSemaphore(value: 6) // tune concurrency

    init(session: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.allowsConstrainedNetworkAccess = true
        config.httpMaximumConnectionsPerHost = 6
        return URLSession(configuration: config)
    }()) {
        self.session = session
        memory.totalCostLimit = 80 * 1024 * 1024
    }

    func image(for url: URL, targetSize: CGSize? = nil) async throws -> UIImage {
        if let cached = memory.object(forKey: url as NSURL) { return cached }
        if let data = disk.read(url: url) {
            let img = targetSize.map { ImageDownsampler.downsample(data: data, to: \$0) } ?? UIImage(data: data)
            if let img {
                memory.setObject(img, forKey: url as NSURL, cost: img.memoryCost)
                return img
            }
        }
        if let task = inflight[url] {
            return try await task.value
        }

        let task = Task { () throws -> UIImage in
            defer { Task { await self.removeInflight(url) } }
            await self.semaphore.wait()
            defer { self.semaphore.signal() }

            let (data, response) = try await self.session.data(from: url)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            _ = try? self.disk.write(data: data, for: url)
            let img = targetSize.map { ImageDownsampler.downsample(data: data, to: \$0) } ?? UIImage(data: data)
            guard let image = img else { throw URLError(.cannotDecodeContentData) }
            self.memory.setObject(image, forKey: url as NSURL, cost: image.memoryCost)
            return image
        }
        inflight[url] = task
        return try await task.value
    }

    func prefetch(urls: [URL], targetSize: CGSize?) {
        Task.detached(priority: .utility) { [weak self] in
            for url in urls {
                _ = try? await self?.image(for: url, targetSize: targetSize)
            }
        }
    }

    private func removeInflight(_ url: URL) {
        inflight[url] = nil
    }
}

private extension UIImage {
    var memoryCost: Int {
        guard let cg = cgImage else { return 1 }
        return cg.bytesPerRow * cg.height
    }
}

// MARK: - ViewModels

struct StudentCellViewModel: Hashable {
    let id: String
    let name: String
    let avatarURL: URL
    init(student: Student) {
        id = student.id
        name = student.name
        avatarURL = student.avatarURL
    }
}

@MainActor
final class StudentListViewModel {
    enum State { case loading, loaded([StudentCellViewModel]), error(String) }
    private let repo: StudentsRepository
    private(set) var state: State = .loading {
        didSet { onStateChange?(state) }
    }
    var onStateChange: ((State) -> Void)?

    init(repo: StudentsRepository) { self.repo = repo }

    func bind() {
        Task {
            state = .loading
            for await students in repo.studentsStream() {
                let vms = students.map(StudentCellViewModel.init)
                state = .loaded(vms)
            }
        }
    }

    func refresh() {
        Task {
            do { try await repo.refresh() }
            catch { state = .error("Failed to refresh. Showing cached data.") }
        }
    }

    func makeDetailVM(for cellVM: StudentCellViewModel) -> StudentDetailViewModel {
        StudentDetailViewModel(student: cellVM)
    }
}

@MainActor
final class StudentDetailViewModel {
    let student: StudentCellViewModel
    init(student: StudentCellViewModel) { self.student = student }
}

// MARK: - UI: Cells

final class StudentTableViewCell: UITableViewCell {
    static let reuseID = "StudentCell"
    private let avatar = UIImageView()
    private let nameLabel = UILabel()
    private var task: Task<Void, Never>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); setupUI() }

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        task = nil
        avatar.image = placeholderImage()
        nameLabel.text = nil
    }

    func configure(with vm: StudentCellViewModel) {
        nameLabel.text = vm.name
        avatar.image = placeholderImage()
        let size = CGSize(width: 56, height: 56)
        task = Task { [weak self] in
            guard let self else { return }
                let img = try? await ImageLoader.shared.image(for: vm.avatarURL, targetSize: size)
            if !Task.isCancelled {
                self.avatar.image = img ?? self.placeholderImage()
            }
        }
    }

    private func setupUI() {
        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        
        avatar.layer.cornerRadius = 28
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.backgroundColor = UIColor.systemGray5
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = UIColor.label
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 56),
            avatar.heightAnchor.constraint(equalToConstant: 56),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.heightAnchor.constraint(equalToConstant: 72).isActive = true
    }
    
    private func placeholderImage() -> UIImage? {
        UIImage(systemName: "person.circle.fill")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
    }
}

// MARK: - Student Detail View Controller

final class StudentDetailViewController: UIViewController {
    private let viewModel: StudentDetailViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    private var imageLoadTask: Task<Void, Never>?
    
    init(viewModel: StudentDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureContent()
        loadImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Student Details"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailsLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Avatar styling
        avatarImageView.layer.cornerRadius = 75
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = UIColor.systemGray5
        avatarImageView.image = UIImage(systemName: "person.circle.fill")?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
        
        // Name label styling
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .label
        
        // Details label styling
        detailsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        detailsLabel.textAlignment = .center
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func configureContent() {
        nameLabel.text = viewModel.student.name
        detailsLabel.text = "Student ID: \(viewModel.student.id)\n\nThis is a detailed view for the selected student. Here you can display additional information about the student such as enrollment details, courses, grades, and other relevant data."
    }
    
    private func loadImage() {
        let size = CGSize(width: 150, height: 150)
        imageLoadTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                let image = try await ImageLoader.shared.image(for: self.viewModel.student.avatarURL, targetSize: size)
                if !Task.isCancelled {
                    await MainActor.run {
                        self.avatarImageView.image = image
                    }
                }
            } catch {
                print("Failed to load detail image: \(error)")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageLoadTask?.cancel()
    }
}

// MARK: - Main View Controller

final class ViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel: StudentListViewModel
    private let refreshControl = UIRefreshControl()
    
    init() {
        // Create mock API client that generates 1000 students
        let mockAPI = MockAPIClient()
        let store = CoreDataStudentsStore()
        let repo = DefaultStudentsRepository(api: mockAPI, store: store)
        self.viewModel = StudentListViewModel(repo: repo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.bind()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Students (1000)"
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(StudentTableViewCell.self, forCellReuseIdentifier: StudentTableViewCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        
        // Add refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // Performance optimizations
        tableView.rowHeight = 72
        tableView.estimatedRowHeight = 72
        tableView.separatorStyle = .singleLine
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.handleStateChange(state)
            }
        }
    }
    
    private func handleStateChange(_ state: StudentListViewModel.State) {
        refreshControl.endRefreshing()
        
        switch state {
        case .loading:
            // Show loading indicator if needed
            break
        case .loaded:
            tableView.reloadData()
        case .error(let message):
            showError(message)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func refreshData() {
        viewModel.refresh()
    }
}

// MARK: - TableView DataSource & Delegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .loaded(let students) = viewModel.state else { return 0 }
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case .loaded(let students) = viewModel.state,
              let cell = tableView.dequeueReusableCell(withIdentifier: StudentTableViewCell.reuseID, for: indexPath) as? StudentTableViewCell else {
            return UITableViewCell()
        }
        
        let student = students[indexPath.row]
        cell.configure(with: student)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard case .loaded(let students) = viewModel.state else { return }
        let student = students[indexPath.row]
        let detailVM = viewModel.makeDetailVM(for: student)
        let detailVC = StudentDetailViewController(viewModel: detailVM)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - TableView Prefetching

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard case .loaded(let students) = viewModel.state else { return }
        
        let urls = indexPaths.compactMap { indexPath in
            guard indexPath.row < students.count else { return nil }
            return students[indexPath.row].avatarURL
        }
        
        let targetSize = CGSize(width: 56, height: 56)
        ImageLoader.shared.prefetch(urls: urls, targetSize: targetSize)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        // Note: In a production app, you might want to cancel specific prefetch tasks
        // For now, the ImageLoader handles this through its semaphore and task management
    }
}

// MARK: - Mock API Client for 1000 Students

final class MockAPIClient: APIClient {
    func fetchStudents() async throws -> [Student] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        return (1...1000).map { index in
            Student(
                id: "student_\(index)",
                name: "Student \(index)",
                avatarURL: URL(string: "https://picsum.photos/200/200?random=\(index)")!,
                details: "Details for student \(index). This student is enrolled in various courses and has a great academic record.",
                updatedAt: Date(),
                avatarDiskPath: nil
            )
        }
    }
}

// MARK: - Scene Delegate Integration

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - App Delegate (fallback for iOS 12 and below)

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            // Scene delegate will handle this
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            let viewController = ViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
