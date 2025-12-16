//
//  15_State.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 09/12/25.
//

import SwiftUI

/*
 
 @State
  - is a property wrapper around a variable
  - used to manage local state within a SwiftUI view
  - when the state variable changes, SwiftUI automatically re-renders the view to reflect the updated state
  - typically used for simple, view-specific state management
 */

struct _5_State: View {
  
  @State var backgroundColor: Color = .green
  @State var title: String = "Title"
  @State var count: Int = 0
  
  var body: some View {
    
    ZStack {
      background
      
      content
    }
    
  }
  
  var background: some View {
    backgroundColor
      .ignoresSafeArea()
  }
  
  var content: some View {
    VStack(spacing: 20) {
      Text(title)
        .font(.title)
      Text("Count: \(count)")
        .font(.headline)
        .underline()
      
      HStack(spacing: 20) {
        Button("Button 1") {
          backgroundColor = .blue
          title = "Button 1 Pressed"
          count += 1
        }
        Button("Button 2") {
          backgroundColor = .gray
          title = "Button 2 Pressed"
          count -= 1
        }
      }
    }
    .foregroundStyle(.white)
  }
}

#Preview {
  _5_State()
}
