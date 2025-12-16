//
//  14_Button.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 09/12/25.
//

import SwiftUI

struct _4_Button: View {
  
  @State var title: String = "This is my title"
  
  var body: some View {
    
    VStack(spacing: 20) {
      Text(title)
      
      Button("Press button 1") {
        self.title = "Button 1 Pressed!"
      }
      .tint(.red)
      
      // Button with label, label can be any view
      Button {
        self.title = "Button 2 Pressed!"
      } label: {
        Text("Press button 2")
      }
      
      Button {
        self.title = "Save Pressed!"
      } label: {
        Text("SAVE")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundStyle(.white)
          .padding()
          .padding(.horizontal, 20)
          .background(
            Color.blue
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .shadow(radius: 10)
          )
      }
      
      Button {
        self.title = "Button 3 Pressed!"
      } label: {
        Circle()
          .fill(.white)
          .frame(width: 75, height: 75)
          .shadow(radius: 10)
          .overlay {
            Image(systemName: "star.fill")
              .font(.largeTitle)
              .foregroundStyle(.green)
          }
      }
      
      Button {
        self.title = "Finish Pressed!"
      } label: {
        Text("FINISH")
          .font(.caption)
          .bold()
          .foregroundStyle(.gray)
          .padding()
          .padding(.horizontal, 10)
          .background(
            Capsule()
              .stroke(.gray, lineWidth: 2.0)
          )
      }
    }
  }
}

#Preview {
  _4_Button()
}
