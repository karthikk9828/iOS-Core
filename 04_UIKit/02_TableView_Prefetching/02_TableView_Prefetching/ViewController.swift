//
//  ViewController.swift
//  02_TableView_Prefetching
//
//  Created by Karthik K on 07/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let numberOfItems = 200
    private var imageUrls: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TableView Prefetching Demo"
        view.backgroundColor = .systemBackground
        
        // Generate unique URLs for each cell (to get different random images)
        imageUrls = (1...numberOfItems).map { index in
            "https://picsum.photos/200?random=\(index)"
        }
        
        setupTableView()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        view.addSubview(tableView)
        
        // Configure table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self // Enable prefetching
        
        // Register cell
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        
        // Set row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 104
        
        // Layout constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        print("✨ TableView setup complete with prefetching enabled")
        print("📊 Total items: \(numberOfItems)")
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as? ImageTableViewCell else {
            return UITableViewCell()
        }
        
        let text = "Hello \(indexPath.row + 1)"
        let imageUrl = imageUrls[indexPath.row]
        
        // Configure cell with text
        cell.configure(with: text, image: nil)
        
        // Load image
        ImageLoader.shared.loadImage(from: imageUrl) { [weak cell] image in
            // Verify the cell is still showing the same content
            if cell?.titleLabel.text == text {
                cell?.configure(with: text, image: image)
            }
        }
        
        print("🔄 Cell configured for row \(indexPath.row + 1)")
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("👆 Selected: Hello \(indexPath.row + 1)")
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension ViewController: UITableViewDataSourcePrefetching {
    
    // Prefetch images for cells that are about to be displayed
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("🚀 Prefetching images for rows: \(indexPaths.map { $0.row + 1 })")
        
        let urls = indexPaths.map { imageUrls[$0.row] }
        ImageLoader.shared.prefetchImages(for: urls)
    }
    
    // Cancel prefetch when cells are no longer needed
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("🚫 Cancelling prefetch for rows: \(indexPaths.map { $0.row + 1 })")
        
        let urls = indexPaths.map { imageUrls[$0.row] }
        ImageLoader.shared.cancelPrefetch(for: urls)
    }
}

