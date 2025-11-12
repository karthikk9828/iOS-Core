//
//  DestinationTab.swift
//  02_MapKit-SwiftUI
//
//  Created by Karthik K on 15/10/25.
//

import SwiftUI
import MapKit
import SwiftData

struct DestinationLocationsMapView: View {
  
  @State private var cameraPosition: MapCameraPosition = .automatic
  @State private var visibleRegion: MKCoordinateRegion?
  
  @Query private var destinations: [Destination]
  @State private var destination: Destination?
  
  var body: some View {
    Map(position: $cameraPosition) {
      
      if let destination {
        ForEach(destination.placeMarks) { place in
          Marker(coordinate: place.coordinate) {
            Label(place.name, systemImage: "star")
          }
          .tint(.yellow)
        }
      }
      
      // Markers
      
//      Marker("Home 1", coordinate: .home1)
//      Marker(coordinate: .home2) {
//        Label("Home 2", systemImage: "house.fill")
//      }
//      .tint(.green)
//      Marker("Home 3", image: "eiffelTower", coordinate: .home3)
//        .tint(.blue)
//      Marker("Home 4", monogram: Text("H4"), coordinate: .home4)
//        .tint(.accent)
//      Marker("Home 5", systemImage: "person.crop.artframe", coordinate: .home5)
//        .tint(.gray)
      
      // Custom Annotations
      
//      Annotation("Annotation 1", coordinate: .ann1) {
//        Image(systemName: "star")
//          .imageScale(.large)
//          .foregroundStyle(.red)
//          .padding(10)
//          .background(.white)
//          .clipShape(.circle)
//      }
//      
//      Annotation("Annotation 2", coordinate: .ann2, anchor: .center) {
//        Image(.sacreCoeur)
//          .resizable()
//          .scaledToFit()
//          .frame(width: 40, height: 40)
//      }
//      
//      Annotation("Annotation 3", coordinate: .ann3) {
//        Image(systemName: "mappin")
//          .imageScale(.large)
//          .foregroundStyle(.teal)
//          .padding(5)
//          .overlay {
//            Circle()
//              .stroke(.teal, lineWidth: 2)
//          }
//      }
      
      // Map Circle
      
//      MapCircle(center: .home1, radius: 50)
//        .foregroundStyle(.red.opacity(0.5))
      
    }
    .onMapCameraChange(frequency: .onEnd) { context in
      visibleRegion = context.region
    }
    .onAppear {
//      let home: CLLocationCoordinate2D = .home1
//      let homeSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
//      let homeRegion = MKCoordinateRegion(center: home, span: homeSpan)
//      
//      cameraPosition = .region(homeRegion)
      
      destination = destinations.first
      if let region = destination?.region {
        cameraPosition = .region(region)
      }
    }
  }
}

#Preview {
  DestinationLocationsMapView()
    .modelContainer(Destination.preview)
}
