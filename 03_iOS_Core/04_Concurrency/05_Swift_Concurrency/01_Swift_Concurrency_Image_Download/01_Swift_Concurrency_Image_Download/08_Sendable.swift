//
//  08_Sendable.swift
//  01_Swift_Concurrency_Image_Download
//
//  Created by Karthik K on 03/11/25.
//

import SwiftUI

/*
  - Sendable is a protocol in Swift
  - Used when a type is safe to be passed into concurrent code (ex: actor)
  - Ex: A class is passed to an actor, that class is being passed to a thread-safe actor
*/

actor CurrentUserManager {

  func update1(_ userInfo: String) {
    
  }
  
  func update2(_ userInfo: UserInfo1) {
    
  }
  
  func update3(_ userInfo: UserInfo2) {
    
  }
  
  func update4(_ userInfo: UserInfo3) {
    
  }
}

/*
   Structs are value types, so they can be safely passed to an actor
*/
struct UserInfo1: Sendable {
  let userName: String
}

/*
  This class does not have any mutable state, so it is safe to be passed to an actor
*/
final class UserInfo2: Sendable {
  let userName: String
  
  init(userName: String) {
    self.userName = userName
  }
}

/*
  - This class has mutable state, so it is NOT safe to be passed to an actor, To make it safe, we can use @unchecked Sendable
  - This is dangerous, because we are telling the compiler to trust us that this class is safe to be passed to an actor
  - We need to ensure that we are not accessing/modifying the mutable properties from multiple threads
  - Make the sure the class is thread-safe
*/
final class UserInfo3: @unchecked Sendable {
  private var userName: String
  let queue = DispatchQueue(label: "com.userinfo.queue")
  
  init(userName: String) {
    self.userName = userName
  }
  
  func update(userName: String) {
    queue.async {
      self.userName = userName
    }
  }
}

class SendableViewModel: ObservableObject {
  
  let manager = CurrentUserManager()
  
  func updateUser() async {
    
    // String (Value type) passed to an actor
    // String conforms to Sendable, no issues
    // All value types conform to Sendable by default
    let info1 = "User Info"
    await manager.update1(info1)
    
    // Struct passed to an actor
    let info2 = UserInfo1(userName: "User Info")
    await manager.update2(info2)
    
    // Class passed to an actor
    // Class should be final and conform to Sendable
    let info3 = UserInfo2(userName: "User Info")
    await manager.update3(info3)
    
    // Unchecked sendable class with mutable properties
    let info4 = UserInfo3(userName: "User Info")
    await manager.update4(info4)
  }
}

struct _8_Sendable: View {
  
  @StateObject private var viewModel = SendableViewModel()
  
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      .task {
        
      }
  }
}

#Preview {
  _8_Sendable()
}
