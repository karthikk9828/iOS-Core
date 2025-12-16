//
//  12_ScrollView.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 26/11/25.
//

import SwiftUI

struct Vertical_ScrollView: View {
  
  var body: some View {
    
    ScrollView {
      VStack {
        ForEach(0 ..< 50) { index in
          Rectangle()
            .fill(.blue)
            .frame(height: 300)
        }
      }
    }
//    .scrollIndicators(.hidden)
    
  }
  
}

struct Horizontal_ScrollView: View {
  
  var body: some View {
    
    ScrollView(.horizontal) {
      HStack {
        ForEach(0 ..< 50) { index in
          Rectangle()
            .fill(.blue)
            .frame(width: 300, height: 300)
        }
      }
    }
    //    .scrollIndicators(.hidden)
    
  }
  
}

struct Nested_ScrollView: View {
  
  var body: some View {
    
    /*
     VStack / HStack will create all the views when the view loads. Only use it if we have smaller number of views inside the stack.
     
     Use LazyVStack / LazyHStack when we have larger number of views inside the stack. It will create views on demand as they come into the viewport.
     */
    ScrollView {
      LazyVStack {
        ForEach(0 ..< 100) { index in
          
          ScrollView(.horizontal) {
            
            LazyHStack {
              ForEach(0 ..< 100) { index in
                RoundedRectangle(cornerRadius: 25)
                  .fill(.white)
                  .frame(width: 200, height: 150)
                  .shadow(radius: 10)
                  .padding()
              }
            }
            
          }
          
        }
      }
    }
    
  }
  
}

#Preview("Vertical_ScrollView") {
  Vertical_ScrollView()
}

#Preview("Horizontal_ScrollView") {
  Horizontal_ScrollView()
}

#Preview("Nested_ScrollView") {
  Nested_ScrollView()
}

