//
//  08_Background_Overlay.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 26/11/25.
//

import SwiftUI

/**
 
 Background: Adds views behind the existing view.
 Overlay: Adds views on top of the existing view.
 
 */

struct Background: View {
  
  var body: some View {
    
    // background can be a color, gradient, shape, view etc.
    Text("Hello, World!")
      .background(
        
//        Color.red
        
        Circle()
          .fill(.blue)
          .frame(width: 100, height: 100)
        
      )
      .background(
        Circle()
          .fill(.green)
          .frame(width: 200, height: 200)
      )
    
  }
  
}

struct Overlay: View {
  
  var body: some View {
    
    VStack(spacing: 130) {
      
      Circle()
        .fill(.blue)
        .frame(width: 100, height: 100)
        .overlay(
          
          Text("Overlay")
            .foregroundColor(.white)
            .font(.title)
        )
        .background(
          Circle()
            .fill(.green)
            .frame(width: 200, height: 200)
        )
      
      Rectangle()
        .frame(width: 100, height: 100)
        .overlay(
          Rectangle()
            .fill(.blue)
            .frame(width: 50, height: 50),
          alignment: .topTrailing
        )
        .background(
          Rectangle()
            .fill(.green)
            .frame(width: 150, height: 150),
          alignment: .bottomLeading
        )
      
      Image(systemName: "star.fill")
        .font(.largeTitle)
        .background(
          Circle()
            .fill(.blue.gradient)
            .frame(width: 100, height: 100)
            .shadow(color: .blue, radius: 10, x: 0, y: 5)
            .overlay(
              Circle()
                .fill(.red)
                .frame(width: 35, height: 35)
                .overlay(
                  Text("5")
                    .foregroundColor(.white)
                    .font(.headline)
                )
                .shadow(color: .red, radius: 10, x: 5, y: 5),
              alignment: .bottomTrailing
            )
        )
      
    }
    
  }
  
}

#Preview {
  Background()
}

#Preview {
  Overlay()
}
