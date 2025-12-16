//
//  _1_PushNotificationsApp.swift
//  01_PushNotifications
//
//  Created by Karthik K on 15/11/25.
//

import SwiftUI

@main
struct _1_PushNotificationsApp: App {
  
  @UIApplicationDelegateAdaptor var appDelegate: CustomAppDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear {
          appDelegate.app = self
        }
    }
  }
}
