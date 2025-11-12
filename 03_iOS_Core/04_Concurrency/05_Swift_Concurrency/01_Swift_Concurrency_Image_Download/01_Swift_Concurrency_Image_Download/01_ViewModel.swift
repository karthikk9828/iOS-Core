//
//  ViewModel.swift
//  01_ImageDownload_AsyncAwait
//
//  Created by Karthik K on 17/10/25.
//

import SwiftUI
import Combine

class ViewModel:ObservableObject {
  
  @Published var image: UIImage? = nil
  private let imageLoader = ImageLoader()
  
  var cancellables = Set<AnyCancellable>()
  
  // Using escaping closure
  func fetchImageUsingEscapingClosure() {
    imageLoader.fetchImageUsingEscapingClosure { [weak self] result in
      
      guard let self = self else { return }
      
      // Similar to DispatchQueue.main.async, uses main queue for UI updates
      Task { @MainActor in
        switch result {
        case .success(let image):
          self.image = image
        case .failure(_):
          self.image = UIImage(systemName: "person.circle.fill")
        }
      }
    }
  }
  
  // Using Combine
  func fetchImageUsingCombine() {
    imageLoader.fetchImageUsingCombine()
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: { [weak self] image in
        self?.image = image
      }
      .store(in: &cancellables)
  }
  
  // Using async/await
  func fetchImageUsingAsyncAwait() async {
    let image = try? await imageLoader.fetchImageUsingAsyncAwait()
    
    // Imagine we don't have above API call which runs on background thread,
    // This sleep function also runs on background thread, next statements also run on background thread
    try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
    
    // Since Task.sleep ran on background thread, we need to switch to main thread for UI updates
    
    // Similar to DispatchQueue.main.async, uses main queue for UI updates
    await MainActor.run {
      self.image = image
    }
  }
  
}
