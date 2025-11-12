//
//  ImageLoader.swift
//  02_TableView_Prefetching
//
//  Created by Karthik K on 07/11/25.
//

import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private var imageCache = NSCache<NSString, UIImage>()
    private var runningTasks = [URL: URLSessionDataTask]()
    
    private init() {
        // Configure cache
        imageCache.countLimit = 100
        imageCache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    // Load image from URL with caching
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Each call to picsum.photos/200 returns a random image
        // We'll use a unique URL for each index to get different images
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Check cache first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            print("📦 Image loaded from cache: \(urlString)")
            completion(cachedImage)
            return
        }
        
        // Check if already downloading
        if let _ = runningTasks[url] {
            print("⏳ Image already being downloaded: \(urlString)")
            return
        }
        
        // Download image
        print("⬇️ Starting download: \(urlString)")
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.runningTasks.removeValue(forKey: url)
            }
            
            if let error = error {
                print("❌ Error downloading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("❌ Invalid image data")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Cache the image
            self?.imageCache.setObject(image, forKey: urlString as NSString)
            print("✅ Image downloaded and cached: \(urlString)")
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        runningTasks[url] = task
        task.resume()
    }
    
    // Prefetch images
    func prefetchImages(for urls: [String]) {
        for urlString in urls {
            // Skip if already cached or downloading
            if imageCache.object(forKey: urlString as NSString) != nil {
                continue
            }
            
            if let url = URL(string: urlString), runningTasks[url] != nil {
                continue
            }
            
            // Start prefetching
            loadImage(from: urlString) { _ in
                // Image will be cached for later use
            }
        }
    }
    
    // Cancel prefetching
    func cancelPrefetch(for urls: [String]) {
        for urlString in urls {
            guard let url = URL(string: urlString) else { continue }
            
            if let task = runningTasks[url] {
                print("🚫 Cancelling prefetch: \(urlString)")
                task.cancel()
                runningTasks.removeValue(forKey: url)
            }
        }
    }
    
    // Clear cache
    func clearCache() {
        imageCache.removeAllObjects()
        runningTasks.values.forEach { $0.cancel() }
        runningTasks.removeAll()
    }
}

