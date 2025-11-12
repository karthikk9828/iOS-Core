//
//  04_TaskGroup.swift
//  01_ImageDownload_AsyncAwait
//
//  Created by Karthik K on 20/10/25.
//

import SwiftUI

class TaskGroupAPIManager {
  
  /*
   Use async let when we know the exact number of concurrent tasks to be executed.
  */
  func fetchImagesWithAsyncLet() async throws -> [UIImage] {
    let url = "https://picsum.photos/200"
    
    async let fetchImage1 = fetchImage(url)
    async let fetchImage2 = fetchImage(url)
    async let fetchImage3 = fetchImage(url)
    async let fetchImage4 = fetchImage(url)
    async let fetchImage5 = fetchImage(url)
    async let fetchImage6 = fetchImage(url)
    
    let (image1, image2, image3, image4, image5, image6) = await (
      try fetchImage1,
      try fetchImage2,
      try fetchImage3,
      try fetchImage4,
      try fetchImage5,
      try fetchImage6
    )
    
    return [image1, image2, image3, image4, image5, image6]
  }
  
  /*
   Use async let when we don't know the exact number of concurrent tasks to be executed.
   When we have dynamic number of tasks to be executed concurrently, we can use TaskGroup.
   */
  func fetchImagesWithTaskGroup() async throws -> [UIImage] {
    let url = "https://picsum.photos/200"
    let urls = [String](repeating: url, count: 6)
    
    return try await withThrowingTaskGroup(of: UIImage?.self) { group in
      
      var images: [UIImage] = []
      images.reserveCapacity(urls.count + 6)
      
      group.addTask { try? await self.fetchImage(url) }
      group.addTask { try? await self.fetchImage(url) }
      group.addTask { try? await self.fetchImage(url) }
      group.addTask { try? await self.fetchImage(url) }
      group.addTask { try? await self.fetchImage(url) }
      group.addTask { try? await self.fetchImage(url) }
      
      // add tasks using for loop
      for url1 in urls {
        group.addTask { try? await self.fetchImage(url1) }
      }
      
      for try await image in group {
        if let image = image {
          images.append(image)
        }
      }
      
      return images
    }
  }
  
  private func fetchImage(_ urlString: String) async throws -> UIImage {
    guard let url = URL(string: urlString) else {
      throw URLError(.badURL)
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      if let image = UIImage(data: data) {
        return image
      }
      
      throw URLError(.badURL)
    } catch {
      throw error
    }
  }
  
}

class TaskGroupViewModel: ObservableObject {
  @Published var images: [UIImage] = []
  
  let manager = TaskGroupAPIManager()
  
  func getImages() async {
//    if let images = try? await manager.fetchImagesWithAsyncLet() {
//      self.images.append(contentsOf: images)
//    }
    
    if let images = try? await manager.fetchImagesWithTaskGroup() {
      self.images.append(contentsOf: images)
    }
  }
}

struct _4_TaskGroup: View {
  
  @StateObject private var viewModel = TaskGroupViewModel()
  
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(viewModel.images, id: \.self) { image in
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .frame(height: 150)
          }
        }
      }
      .navigationTitle("Task Group Concurrency")
      .task {
        await viewModel.getImages()
      }
    }
  }
  
}

#Preview {
    _4_TaskGroup()
}
