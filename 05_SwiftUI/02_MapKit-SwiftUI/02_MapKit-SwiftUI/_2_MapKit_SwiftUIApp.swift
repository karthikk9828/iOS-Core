//
//  _2_MapKit_SwiftUIApp.swift
//  02_MapKit-SwiftUI
//
//  Created by Karthik K on 15/10/25.
//

import SwiftUI
import SwiftData

@main
struct _2_MapKit_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Destination.self)
    }
}
