//
//  06_Actors.swift
//  01_Swift_Concurrency_Image_Download
//
//  Created by Karthik K on 03/11/25.
//

import SwiftUI

class DataManager1 {
  static let shared = DataManager1()
  
  private init() {}
  
  private var data: [String] = []
  
  private let queue = DispatchQueue(label: "com.datamanager.queue")
  
  /*
   - This function is not thread-safe. If called from multiple threads simultaneously,
   - Causes data race
  */
  func getRandomData1() -> String? {
    data.append(UUID().uuidString)
    print(Thread.current)
    return data.randomElement()
  }
  
  /*
    - This function is thread-safe. It uses a serial dispatch queue to ensure that
  */
  func getRandomData(_ completion: @escaping (_ title: String?) -> Void) {
    queue.async {
      self.data.append(UUID().uuidString)
      print(Thread.current)
      completion(self.data.randomElement())
    }
  }
}

actor DataManager2 {
  static let shared = DataManager2()
  
  private init() {}
  
  private var data: [String] = []
  
  func getRandomData1() -> String? {
    data.append(UUID().uuidString)
    print(Thread.current)
    return data.randomElement()
  }
  
  /*
   - Opt out of actor isolation for this property since it is a constant and immutable.
   - No need to use `await` when calling this function from outside the actor.
   */
  let titles = ["One", "Two", "Three", "Four", "Five"]
  
  /*
    - This function does not need actor isolation since it is not accessing any mutable state of the actor.
    - No need to use `await` when calling this function from outside the actor.
  */
  nonisolated func getSavedData() -> String {
    
    // We cannot access isolated state of the actor from a nonisolated context
    // let data1 = self.data
    // let data2 = self.getRandomData1()
    
    return " New data"
  }
}

struct HomeView: View {
  
  @State private var text: String = ""
  
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
//  let manager = DataManager1.shared
  let manager = DataManager2.shared
  
  var body: some View {
    ZStack {
      Color.gray.opacity(0.8).ignoresSafeArea()
      Text(text)
        .font(.headline)
    }
    .onReceive(timer) { _ in
//      DispatchQueue.global(qos: .background).async {
//        manager.getRandomData() { data in
//          if let data {
//            DispatchQueue.main.async {
//              self.text = data
//            }
//          }
//        }
//      }
      
      Task {
        if let data = await manager.getRandomData1() {
          await MainActor.run {
            self.text = data
          }
        }
      }
    }
  }
}

struct BrowseView: View {
  
  @State private var text: String = ""
  
  let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
  
//  let manager = DataManager1.shared
  let manager = DataManager2.shared
  
  var body: some View {
    ZStack {
      Color.yellow.opacity(0.8).ignoresSafeArea()
      Text(text)
        .font(.headline)
    }
    .onReceive(timer) { _ in
//      DispatchQueue.global(qos: .default).async {
//        manager.getRandomData() { data in
//          if let data {
//            DispatchQueue.main.async {
//              self.text = data
//            }
//          }
//        }
//      }
            
      Task {
        if let data = await manager.getRandomData1() {
          await MainActor.run {
            self.text = data
          }
        }
      }
    }
  }
}

struct _6_Actors: View {
    var body: some View {
      TabView {
        HomeView()
          .tabItem {
            Label("Home", systemImage: "house")
          }
        BrowseView()
          .tabItem {
            Label("Browse", systemImage: "magnifyingglass")
          }
      }
    }
}

#Preview {
    _6_Actors()
}
