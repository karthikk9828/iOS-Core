//
//  HomeScreen.swift
//  02_MapKit-SwiftUI
//
//  Created by Karthik K on 15/10/25.
//

import SwiftUI

struct HomeScreen: View {
  
  var body: some View {
    TabView {
      Group {
        MyTripsMapView()
          .tabItem {
            Label("TripMap", systemImage: "map")
          }
        DestinationLocationsMapView()
          .tabItem {
            Label("Destinations", systemImage: "globe.desk")
          }
      }
      .toolbarBackground(.appBlue.opacity(0.8), for: .tabBar)
      .toolbarBackground(.visible, for: .tabBar)
      .toolbarColorScheme(.dark, for: .tabBar)
    }
  }
}


#Preview {
  HomeScreen()
}
