//
//  02_Task.swift
//  01_ImageDownload_AsyncAwait
//
//  Created by Karthik K on 19/10/25.
//

import SwiftUI

class TaskViewModel: ObservableObject {
  
  @Published var image1: UIImage? = nil
  @Published var image2: UIImage? = nil
  
  func fetchImage1() async {
    
    // sleep for task cancellation testing
    try? await Task.sleep(nanoseconds: 5_000_000_000)
    
    do {
      guard let url = URL(string: "https://picsum.photos/200") else { return }
      
      let (data, _) = try await URLSession.shared.data(from: url)
            
      Task { @MainActor in
        print("Downloaded image successfully")
        self.image1 = UIImage(data: data)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func fetchImage2() async {
    do {
      guard let url = URL(string: "https://picsum.photos/200") else { return }
      
      let (data, _) = try await URLSession.shared.data(from: url)
      
      self.image2 = UIImage(data: data)
    } catch {
      print(error.localizedDescription)
    }
  }
}

struct _2_Task: View {
  
  @StateObject private var viewModel = TaskViewModel()
  
  @State private var imageTask: Task<Void, Never>? = nil
  
  var body: some View {
    VStack(spacing: 40) {
      if let image = viewModel.image1 {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: 250, height: 250)
      }
      
      if let image = viewModel.image2 {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: 250, height: 250)
      }
    }
    // .onAppear gets executed when the view appears
    .onAppear {
      Task {
        // waits for first call, then second call gets executed
        // await viewModel.fetchImage1()
        // await viewModel.fetchImage1()
      }
      
      /* If we don't want to wait and continue with the next call, use separate tasks
      Both these tasks have same priority
      */
      Task {
        print(Thread.current)
        print(Task.currentPriority)
        // await viewModel.fetchImage1()
      }
      Task {
        print(Thread.current)
        print(Task.currentPriority)
        // await viewModel.fetchImage2()
      }
      
      //MARK: - Task Priorities
      
      // We can also specify different priorities for tasks
      // this is the priority order, they may not finish in this order
      Task(priority: .high) {
        
        // try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Instead of Task.sleep, use yield
        // if there are other tasks after this task, suspend this task and they get chance to execute
        // otherwise, it will execute this task
        await Task.yield()
        
        print("high: \(Thread.current), \(Task.currentPriority)")
      }
      Task(priority: .userInitiated) {
        print("userInitiated: \(Thread.current), \(Task.currentPriority)")
      }
      Task(priority: .medium) {
        print("medium: \(Thread.current), \(Task.currentPriority)")
      }
      Task(priority: .low) {
        print("low: \(Thread.current), \(Task.currentPriority)")
      }
      Task(priority: .utility) {
        print("utility: \(Thread.current), \(Task.currentPriority)")
      }
      Task(priority: .background) {
        print("background: \(Thread.current), \(Task.currentPriority)")
      }
      
      //: MARK: - Child tasks
      
      // This is just a simpler way, use Task groups for complex scenarios
      Task(priority: .background) {
        print("background: \(Thread.current), \(Task.currentPriority)")
        
        // Inherits priority from parent task
        Task {
          print("background2.1: \(Thread.current), \(Task.currentPriority)")
        }
        
        // Overrides priority from parent task
        Task(priority: .medium) {
          print("background2.2: \(Thread.current), \(Task.currentPriority)")
        }
        
        // If we don't want a child task to be attached to parent task, use detached
        Task.detached {
          print("detached: \(Thread.current), \(Task.currentPriority)")
        }
        
        //MARK: - Task cancellation
        
        self.imageTask = Task {
          // takes 5 seconds, if we go back before 5 seonds
          // task keeps running in background unless we cancel it
          await viewModel.fetchImage1()
        }
      }
    }
    .onDisappear() {
      // cancel image download task when view disappears
      imageTask?.cancel()
    }
    
    // .task gets executed before the view appears
    .task {
      // When we use .task modifier, SwiftUI automatically cancels the task when the view disappears before the task completes
      // No need to store reference and cancel manually
      // in .onAppear we need to manually cancel it
      await viewModel.fetchImage1()
    }
  }
}

struct TaskHomeView: View {
  var body: some View {
    NavigationStack {
      ZStack {
        NavigationLink("Click Me!") {
          _2_Task()
        }
      }
    }
  }
}

#Preview {
    _2_Task()
}
