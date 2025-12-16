//
//  16_Binding.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 09/12/25.
//

import SwiftUI

/*
  @Binding
    - A property wrapper used to create a two-way connection between a view and its data source.
    - It allows a child view to read and write a value that is owned by a parent view.
    - If child view modifies the value, the change is reflected in the parent view.
*/
struct _6_Binding: View {
  
  @State var backgroundColor: Color = .green
  @State var title: String = "This is the title"
  
  var body: some View {
    
    ZStack {
      backgroundColor
        .ignoresSafeArea()
      
      VStack {
        Text(title)
          .foregroundStyle(.white)
        ButtonView(backgroundColor: $backgroundColor, title: $title)
      }
    }
    
  }
}

struct ButtonView: View {
  
  @Binding var backgroundColor: Color
  @Binding var title: String
  
  var body: some View {
    Button {
      backgroundColor = .gray
      title = "Updated title"
    } label: {
      Text("Button")
        .foregroundStyle(.white)
        .padding()
        .padding(.horizontal)
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
}

#Preview {
  _6_Binding()
}
