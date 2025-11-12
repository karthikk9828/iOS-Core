//
//  MyTripPlaceMark.swift
//  02_MapKit-SwiftUI
//
//  Created by Karthik K on 16/10/25.
//

import SwiftData
import MapKit

@Model
class MyTripPlaceMark {
  var name: String
  var address: String
  var latitude: Double
  var longitude: Double
  var destination: Destination?
  
  init(name: String, address: String, latitude: Double, longitude: Double) {
    self.name = name
    self.address = address
    self.latitude = latitude
    self.longitude = longitude
  }
  
  var coordinate: CLLocationCoordinate2D {
    .init(latitude: latitude, longitude: longitude)
  }
}
