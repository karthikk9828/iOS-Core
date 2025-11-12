# UITableView Prefetching Demo

A demonstration project showcasing UITableView's prefetching API for optimizing performance when loading remote images.

## 📋 Overview

This project demonstrates how to implement UITableView data source prefetching to improve scrolling performance by preloading images before cells become visible.

## 🎯 Features

- **200 Table View Cells**: Displays "Hello 1" through "Hello 200"
- **Remote Images**: Each cell loads a unique random image from `https://picsum.photos/200`
- **Prefetching**: Implements `UITableViewDataSourcePrefetching` protocol
- **Image Caching**: NSCache-based image caching for optimal performance
- **Loading Indicators**: Activity indicators while images are loading
- **Custom Cell Design**: Modern, clean UI with proper constraints

## 🏗️ Project Structure

```
02_TableView_Prefetching/
├── ViewController.swift          # Main view controller with TableView
├── ImageTableViewCell.swift      # Custom cell with image and text
├── ImageLoader.swift              # Singleton for image loading & caching
├── AppDelegate.swift              # App lifecycle
├── SceneDelegate.swift            # Scene lifecycle
└── Base.lproj/
    ├── Main.storyboard            # UI layout
    └── LaunchScreen.storyboard    # Launch screen
```

## 🔑 Key Components

### 1. ViewController
- Implements `UITableViewDataSource`, `UITableViewDelegate`, and `UITableViewDataSourcePrefetching`
- Manages 200 cells with unique image URLs
- Handles prefetching and cell configuration

### 2. ImageTableViewCell
- Custom UITableViewCell with horizontal stack layout
- Contains:
  - 80x80 rounded image view
  - Text label for "Hello X"
  - Activity indicator for loading state

### 3. ImageLoader (Singleton)
- Manages image downloading and caching
- Features:
  - NSCache with 100 image limit and 50MB size limit
  - URL session-based downloads
  - Automatic cache management
  - Task cancellation support for prefetch cancellation

## 🚀 How Prefetching Works

### Prefetching Flow:

1. **User Scrolls**: As user scrolls, UITableView detects upcoming cells
2. **Prefetch Triggered**: `prefetchRowsAt` is called with upcoming index paths
3. **Images Downloaded**: ImageLoader begins downloading images in background
4. **Cache Storage**: Downloaded images are stored in NSCache
5. **Cell Display**: When cell becomes visible, image loads instantly from cache

### Cancellation Flow:

1. **Scroll Direction Change**: User changes scroll direction
2. **Cancel Triggered**: `cancelPrefetchingForRowsAt` is called
3. **Tasks Cancelled**: Active download tasks for those cells are cancelled
4. **Resources Freed**: Network resources are released

## 📊 Console Output

The app includes comprehensive logging to demonstrate prefetching in action:

```
✨ TableView setup complete with prefetching enabled
📊 Total items: 200
🚀 Prefetching images for rows: [10, 11, 12, 13, 14]
⬇️ Starting download: https://picsum.photos/200?random=10
📦 Image loaded from cache: https://picsum.photos/200?random=5
✅ Image downloaded and cached: https://picsum.photos/200?random=10
🚫 Cancelling prefetch for rows: [20, 21, 22]
🔄 Cell configured for row 1
```

## 💡 Benefits of Prefetching

1. **Smoother Scrolling**: Images load before cells become visible
2. **Better UX**: No visible loading delays
3. **Resource Efficient**: Cancels unnecessary downloads
4. **Network Optimization**: Reduces redundant requests via caching
5. **Memory Management**: NSCache automatically manages memory pressure

## 🎨 UI Design

- **Clean Layout**: Horizontal stack view with proper spacing
- **Loading State**: Activity indicators show loading progress
- **Rounded Corners**: 8pt corner radius on images
- **Responsive**: Auto Layout with safe areas
- **Modern**: System fonts and colors

## 🔧 Technical Details

- **iOS Deployment Target**: iOS 18.0
- **Language**: Swift 5.0
- **Architecture**: MVC pattern
- **UI**: Programmatic Auto Layout (no Storyboard for TableView)
- **Networking**: URLSession
- **Caching**: NSCache

## 📝 Implementation Highlights

### UITableViewDataSourcePrefetching Protocol

```swift
func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    // Prefetch images for upcoming cells
    let urls = indexPaths.map { imageUrls[$0.row] }
    ImageLoader.shared.prefetchImages(for: urls)
}

func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    // Cancel unnecessary downloads
    let urls = indexPaths.map { imageUrls[$0.row] }
    ImageLoader.shared.cancelPrefetch(for: urls)
}
```

### Image Caching Strategy

- **Cache Limit**: 100 images
- **Memory Limit**: 50 MB
- **Cache Key**: Full URL string
- **Auto Eviction**: NSCache handles memory pressure

## 🏃‍♂️ Running the Project

1. Open `02_TableView_Prefetching.xcodeproj` in Xcode
2. Select a simulator or device
3. Build and run (⌘ + R)
4. Scroll through the table view
5. Watch the console for prefetching logs

## 📱 Testing Prefetching

To observe prefetching in action:

1. **Enable Console**: Open Xcode console (⌘ + Shift + C)
2. **Run App**: Start the app
3. **Scroll Slowly**: Scroll down slowly to see prefetch messages
4. **Scroll Fast**: Scroll quickly to see cancellation messages
5. **Scroll Back**: Scroll up to see cache hits

## 🎓 Learning Points

- Understanding UITableView prefetching API
- Implementing efficient image loading
- Managing network tasks and cancellation
- Using NSCache for memory management
- Creating custom table view cells
- Handling asynchronous operations
- Preventing cell reuse issues

## 📄 License

This is a learning project for educational purposes.

---

**Created by**: Karthik K  
**Date**: November 7, 2025  
**Purpose**: UIKit TableView Prefetching Learning

