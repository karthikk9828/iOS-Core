//
//  05_CheckedContinuation.swift
//  01_ImageDownload_AsyncAwait
//
//  Created by Karthik K on 21/10/25.
//

/*
 Continuations are used when working with APIs that do not support async/await natively.
 
 Use continuation to convert non-async code to async code.
 ex: URLSession.shared.dataTask is non-async
*/

import SwiftUI

class CheckedContinuationAPIManager {
  
  // ex1: URLSession.shared.dataTask converted to async/await using continuation
  func getData(url: URL) async throws -> Data {
    
    // we should resume the continuation exactly once
    return try await withCheckedThrowingContinuation { continuation in
      URLSession.shared.dataTask(with: url) { data, response, error in
        if let data {
          continuation.resume(returning: data)
        } else if let error {
          continuation.resume(throwing: error)
        } else {
          continuation.resume(throwing: URLError(.badURL))
        }
      }
      .resume()
    }
  }
  
  // ex2:
  // without async/await using completion handler
  func getImage(_ completion: @escaping (UIImage) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      completion(UIImage(systemName: "star")!)
    }
  }
  
  // converted above function to async/await using continuation
  func getImage() async -> UIImage {
    
    // we should resume the continuation exactly once
    return await withCheckedContinuation { continuation in
      getImage { image in
        continuation.resume(returning: image)
      }
    }
  }
  
}

class CheckedContinuationViewModel: ObservableObject {
  
  @Published var image: UIImage? = nil
  
  let manager = CheckedContinuationAPIManager()
  
  func getImage() async {
    guard let url = URL(string: "https://picsum.photos/200") else { return }
    
    do {
      let data = try await manager.getData(url: url)
      if let image = UIImage(data: data) {
        await MainActor.run {
          self.image = image
        }
      }
    } catch {
      print(error)
    }
  }
}

struct _5_CheckedContinuation: View {
  
  @StateObject private var viewModel = CheckedContinuationViewModel()
  
  var body: some View {
    ZStack {
      if let image = viewModel.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: 200, height: 200)
      }
    }
    .task {
      await viewModel.getImage()
    }
  }
}

#Preview {
  _5_CheckedContinuation()
}
