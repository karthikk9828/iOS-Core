//
//  ContentView.swift
//  01_PushNotifications
//
//  Created by Karthik K on 15/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
          Button("Request Push Notification Permission") {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            }
          }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
