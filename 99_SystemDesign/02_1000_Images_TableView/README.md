# 1000 Images TableView with Caching and Prefetching

This project demonstrates a comprehensive iOS app that efficiently displays 1000 images in a UITableView with advanced features.

## Features

### ✅ Core Requirements
- **1000 Images**: Displays exactly 1000 student profiles with images
- **Caching**: Multi-level caching (Memory + Disk) with automatic cleanup
- **Prefetching**: Intelligent image prefetching using `UITableViewDataSourcePrefetching`
- **Concurrent Loading**: Limited concurrent downloads (6 max) with proper queue management
- **Student Details**: Tap any row to view detailed student information
- **CoreData**: All student data persisted locally with offline support

### 🚀 Advanced Features
- **Image Downsampling**: Optimizes memory usage by resizing images to display size
- **Network Monitoring**: Detects online/offline status and constrained networks
- **Deduplication**: Prevents duplicate downloads of the same image
- **Pull-to-Refresh**: Refresh data with pull gesture
- **Modern Async/Await**: Uses latest Swift concurrency features
- **Repository Pattern**: Clean architecture with dependency injection
- **Automatic Cache Cleanup**: LRU-based disk cache with configurable size limits

## Architecture

### Data Flow
```
API Client → Repository → CoreData Store
     ↓
View Model → View Controller → TableView
     ↓
Image Loader (Memory Cache → Disk Cache → Network)
```

### Key Components

1. **ImageLoader**: Concurrent image loading with caching
2. **CoreDataStudentsStore**: Persistent storage with conflict resolution
3. **DiskCache**: Smart disk caching with SHA256-based naming
4. **NetworkMonitor**: Real-time network status monitoring
5. **StudentDetailViewController**: Rich detail view with large avatar

## Performance Optimizations

- **Memory Management**: NSCache with cost-based eviction
- **Disk I/O**: Background queue operations
- **Network**: Connection pooling and constrained network support
- **UI**: Cell reuse, fixed row heights, and prefetching
- **Concurrency**: Actor-based synchronization and semaphore limiting

## Usage

1. Launch the app to see 1000 students loaded from cache
2. Pull down to refresh from network (simulated)
3. Scroll to see automatic image loading and prefetching
4. Tap any student to view detailed information
5. Works offline after initial data load

## Technical Details

- **iOS 15.0+** required for modern async/await support
- **Swift 5.5+** for actor support and structured concurrency
- **No external dependencies** - pure iOS SDK implementation
- **Memory efficient** - handles 1000 images without memory warnings
- **Production ready** - includes error handling, offline support, and cleanup
