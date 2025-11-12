import UIKit

// URLs of the images to download
let imageURLs: [URL] = [] /* array of 1000 image URLs */

// Create an operation queue
let downloadQueue = OperationQueue()
downloadQueue.maxConcurrentOperationCount = 10 // Set the maximum concurrent operations

// Cache to store downloaded images
let downloadedImages = NSCache<NSString, UIImage>()

// Create download operations
for url in imageURLs {
    let downloadOperation = BlockOperation {
        if let imageData = try? Data(contentsOf: url),
           let image = UIImage(data: imageData) {
          downloadedImages.setObject(image, forKey: NSString(string: url.absoluteString))
        }
    }
    downloadQueue.addOperation(downloadOperation)
}

// Add completion block
downloadQueue.addOperation {
    // Handle downloaded images
  print("All images downloaded")
}

