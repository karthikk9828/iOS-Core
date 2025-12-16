//
//  CustomAppDelegate.swift
//  01_PushNotifications
//
//  Created by Karthik K on 15/11/25.
//

import SwiftUI
import UserNotifications

class CustomAppDelegate: NSObject, UIApplicationDelegate {
  
  var app: _1_PushNotificationsApp?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    application.registerForRemoteNotifications()
    
    UNUserNotificationCenter.current().delegate = self
    
    return true
  }
  
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("Device Token: \(tokenString)")
  }
  
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
    print("Notification titile: \(response.notification.request.content.title)")
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
    return [.badge, .banner, .list, .sound]
  }
  
}
