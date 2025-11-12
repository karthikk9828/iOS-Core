
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
        if let cell = cell {
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // Cancel any in-flight requests for data for the specified index paths.
    }
}

extension ViewController: UIScrollViewDelegate {
    
}

// ------------------------------------------------------------------------------------------------------------------

class ImageGridViewController: UIViewController {

    var collectionView: UICollectionView!
    var imageURLs: [URL] = []
    var imageCache = NSCache<NSURL, UIImage>()
    var tasks: [IndexPath: URLSessionDataTask] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadImageURLs()
    }
}

extension ImageGridViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        view.addSubview(collectionView)
    }

    func loadImageURLs() {
        // Simulate loading 1000 image URLs
        for i in 1...1000 {
            if let url = URL(string: "https://example.com/image\(i).jpg") {
                imageURLs.append(url)
            }
        }
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        let url = imageURLs[indexPath.item]
        cell.configure(url: url, cache: imageCache, tasks: &tasks, indexPath: indexPath)
        return cell
    }

    // Prefetch
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let url = imageURLs[indexPath.item]
            if imageCache.object(forKey: url as NSURL) == nil {
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: url as NSURL)
                    }
                }
                task.resume()
                tasks[indexPath] = task
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            tasks[indexPath]?.cancel()
            tasks.removeValue(forKey: indexPath)
        }
    }
}

class ImageCell: UICollectionViewCell {
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = contentView.bounds
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(url: URL, cache: NSCache<NSURL, UIImage>, tasks: inout [IndexPath: URLSessionDataTask], indexPath: IndexPath) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            imageView.image = cachedImage
            return
        }

        imageView.image = nil
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                cache.setObject(image, forKey: url as NSURL)
                self.imageView.image = image
            }
        }
        task.resume()
        tasks[indexPath] = task
    }
}
