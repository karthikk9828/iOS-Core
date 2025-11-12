/**
Refer: 03_iOS_Core/04_Concurrency/05_Swift_Concurrency/01_ImageDownload_AsyncAwait/01_ImageDownload_AsyncAwait/03_AsyncLetConcurrent.swift
*/

import SwiftUI

struct _3_AsyncLetConcurrent: View {
  
  @State private var images: [UIImage] = []
  
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  let url = URL(string: "https://picsum.photos/200")!
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(images, id: \.self) { image in
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .frame(height: 150)
          }
        }
      }
      .navigationTitle("Async Let Concurrency")
    }
    .onAppear {
      Task {
        do {
          /*
           These calls run serially, one after the other in order
           */
          /*
          let image1 = try await fetchImage()
          self.images.append(image1)
          
          let image2 = try await fetchImage()
          self.images.append(image2)
          
          let image3 = try await fetchImage()
          self.images.append(image3)
          
          let image4 = try await fetchImage()
          self.images.append(image4)
          */
          
          /*
           Concurrent API calls using async let
           */
          async let fetchImage1 = fetchImage()
          async let fetchImage2 = fetchImage()
          async let fetchImage3 = fetchImage()
          async let fetchImage4 = fetchImage()
          
          // if we use try await here, any one failure will throw an error and stop all the calls
          // use try? to ignore failures and continue with other calls
          let (image1, image2, image3, image4) = await (
            try? fetchImage1,
            try? fetchImage2,
            try? fetchImage3,
            try? fetchImage4
          )
          
          self.images.append(contentsOf: [image1, image2, image3, image4].compactMap { $0 })
        } catch {
          print(error)
        }
      }
    }
  }
  
  func fetchImage() async throws -> UIImage {
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

#Preview {
  _3_AsyncLetConcurrent()
}
