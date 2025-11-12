//
//  Destination.swift
//  02_MapKit-SwiftUI
//
//  Created by Karthik K on 16/10/25.
//

import SwiftData
import MapKit

@Model
class Destination {
  var name: String
  var latitude: Double?
  var longitude: Double?
  var latitudeDelta: Double?
  var longitudeDelta: Double?
  
  @Relationship(deleteRule: .cascade)
  var placeMarks: [MyTripPlaceMark] = []
  
  init(
    name: String,
    latitude: Double? = nil,
    longitude: Double? = nil,
    latitudeDelta: Double? = nil,
    longitudeDelta: Double? = nil
  ) {
    self.name = name
    self.latitude = latitude
    self.longitude = longitude
    self.latitudeDelta = latitudeDelta
    self.longitudeDelta = longitudeDelta
  }
  
  var region: MKCoordinateRegion? {
    guard let latitude, let longitude, let latitudeDelta, let longitudeDelta else { return nil }
    
    return MKCoordinateRegion(
      center: CLLocationCoordinate2D(
        latitude: latitude,
        longitude: longitude
      ),
      span: MKCoordinateSpan(
        latitudeDelta: latitudeDelta,
        longitudeDelta: longitudeDelta
      )
    )
  }
  
}

extension Destination {
  @MainActor
  static var preview: ModelContainer {
    let container = try! ModelContainer(
      for: Destination.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let location = CLLocationCoordinate2D.home1
    
    let home = Destination(
      name: "Home",
      latitude: location.latitude,
      longitude: location.longitude,
      latitudeDelta: 0.002,
      longitudeDelta: 0.002
    )
    
    container.mainContext.insert(home)
    
    var placeMarks: [MyTripPlaceMark] {
      [
        MyTripPlaceMark(name: "Home 1", address: "#23, 13th main, Hosa road", latitude: CLLocationCoordinate2D.home1.latitude, longitude: CLLocationCoordinate2D.home1.longitude),
        MyTripPlaceMark(name: "Home 2", address: "#134, 10th main, Hosa road", latitude: CLLocationCoordinate2D.home2.latitude, longitude: CLLocationCoordinate2D.home2.longitude),
        MyTripPlaceMark(name: "Home 3", address: "#23, 3rdh main, Hosa road", latitude: CLLocationCoordinate2D.home3.latitude, longitude: CLLocationCoordinate2D.home3.longitude),
        MyTripPlaceMark(name: "Home 4", address: "#23, 4th main, Hosa road", latitude: CLLocationCoordinate2D.home4.latitude, longitude: CLLocationCoordinate2D.home4.longitude),
        MyTripPlaceMark(name: "Home 5", address: "#23, 1st main, Hosa road", latitude: CLLocationCoordinate2D.home5.latitude, longitude: CLLocationCoordinate2D.home5.longitude),
        MyTripPlaceMark(name: "Ann 1", address: "#23, 7th main, Hosa road", latitude: CLLocationCoordinate2D.ann1.latitude, longitude: CLLocationCoordinate2D.ann1.longitude),
        MyTripPlaceMark(name: "Ann 2", address: "#23, 9th main, Hosa road", latitude: CLLocationCoordinate2D.ann2.latitude, longitude: CLLocationCoordinate2D.ann2.longitude),
        MyTripPlaceMark(name: "Ann 3", address: "#23, 8th main, Hosa road", latitude: CLLocationCoordinate2D.ann3.latitude, longitude: CLLocationCoordinate2D.ann3.longitude)
      ]
    }
    
    placeMarks.forEach { placeMark in
      home.placeMarks.append(placeMark)
    }
    
    return container
  }
}
