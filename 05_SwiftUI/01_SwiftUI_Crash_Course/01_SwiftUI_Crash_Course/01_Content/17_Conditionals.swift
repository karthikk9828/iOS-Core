//
//  17_Conditionals.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 09/12/25.
//

import SwiftUI

struct _7_Conditionals: View {
  
  @State var showCircle: Bool = false
  @State var showRectangle: Bool = false
  @State var isLoading: Bool = false
  
  var body: some View {
    
    VStack(spacing: 20) {
      
      if isLoading {
        ProgressView()
      }
      
      Button("isLoading: \(isLoading)") {
        isLoading.toggle()
      }
      
      Button("Circle Button: \(showCircle ? "ON" : "OFF")") {
        showCircle.toggle()
      }
      
      Button("Rectangle Button: \(showRectangle ? "ON" : "OFF")") {
        showRectangle.toggle()
      }
      
      if showCircle {
        Circle()
          .frame(width: 100, height: 100)
      }
      if showRectangle {
        Rectangle()
          .frame(width: 100, height: 100)
      }
      if showCircle && showRectangle {
        RoundedRectangle(cornerRadius: 25)
          .frame(width: 100, height: 100)
      }
    }
    
  }
}

#Preview {
  _7_Conditionals()
}
