//
//  07_GlobalActor.swift
//  01_Swift_Concurrency_Image_Download
//
//  Created by Karthik K on 03/11/25.
//

import SwiftUI

/*

  Global Actors
  - Used when we want to make a non-isolated type to be isolated as part of the actor
 
  - MainActor is a global actor provided by Swift
*/

@globalActor
struct MyGlobalActor {
  static let shared = DataManager3()
}

actor DataManager3 {
  
  func getData() -> [String] {
    return ["One", "Two", "Three", "Four"]
  }
}

class GlobalActorViewModel: ObservableObject {
  
  // isolate data property to MainActor
  @MainActor @Published var data: [String] = []
  
  let manager = MyGlobalActor.shared
  
  /*
    - We can isolate this function to the global actor by annotating
    - Now this function is isolated to the actor
  */
  @MyGlobalActor
  func getData() async {
    let data = await manager.getData()
    await MainActor.run {
      self.data = data
    }
  }
  
  /*
    - MainActor is a global actor provided by Swift
    - Same as above function but using MainActor global actor
  */
  @MainActor
  func getData2() async {
    let data = await manager.getData()
    self.data = data
  }
}

struct _7_GlobalActor: View {
  
  @StateObject private var viewModel = GlobalActorViewModel()
  
  var body: some View {
    ScrollView {
      VStack {
        ForEach(viewModel.data, id: \.self) { item in
          Text(item)
            .font(.headline)
        }
      }
    }
    .task {
      await viewModel.getData()
    }
  }
}

#Preview {
  _7_GlobalActor()
}
