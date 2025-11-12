//
//  ImageLoader.swift
//  01_ImageDownload_AsyncAwait
//
//  Created by Karthik K on 17/10/25.
//

import SwiftUI
import Combine

enum ImageLoaderError: Error {
  case networkError(Error)
  case invalidData
  case invalidResponse
  case unknown
}

class ImageLoader {
  
  let url = URL(string: "https://picsum.photos/200")!
  
  func handleResponse(_ data: Data?, _ response: URLResponse?) -> UIImage? {
    guard let data,
          let image = UIImage(data: data),
          let response = response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode < 300 else {
      return nil
    }
    
    return image
  }
  
  // Using escaping closure
  func fetchImageUsingEscapingClosure(
    _ completion: @escaping (Result<UIImage, Error>) -> ()
  ) {
    
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      let image = self?.handleResponse(data, response)
      
      if let image { completion(.success(image)) }
      else { completion(.failure(ImageLoaderError.unknown)) }
    }
    .resume()
  }
  
  // Using Combine
  func fetchImageUsingCombine() -> AnyPublisher<UIImage, Error> {
    
    URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { output in
        guard let image = self.handleResponse(output.data, output.response) else {
          throw ImageLoaderError.invalidData
        }
        return image
      }
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
  
  // Using async/await
  func fetchImageUsingAsyncAwait() async throws -> UIImage? {
    
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      return handleResponse(data, response)
    } catch {
      throw error
    }
  }
  
}
