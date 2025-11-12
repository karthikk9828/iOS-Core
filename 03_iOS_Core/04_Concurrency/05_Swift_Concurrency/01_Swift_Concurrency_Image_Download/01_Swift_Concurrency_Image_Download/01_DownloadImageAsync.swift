//
//  DownloadImageAsync.swift
//  01_ImageDownload_AsyncAwait
//
//  Created by Karthik K on 17/10/25.
//

import SwiftUI

struct DownloadImageAsync: View {
  
  @StateObject private var viewModel = ViewModel()
  
  var body: some View {
    ZStack {
      if let image = viewModel.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: 250, height: 250)
      }
    }
    .onAppear {
//      viewModel.fetchImageUsingEscapingClosure()
//      viewModel.fetchImageUsingCombine()
      Task {
        await viewModel.fetchImageUsingAsyncAwait()
      }
    }
  }
}

#Preview {
  DownloadImageAsync()
}
