//
//  26_ContextMenu.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

/*
  Context Menu
    - appears when user long-presses on a view
*/
struct _6_ContextMenu: View {
  
  var body: some View {
    
    VStack(alignment: .leading, spacing: 10) {
      Image(systemName: "house.fill")
        .font(.title)
      Text("Context Menu example")
        .font(.headline)
      Text("Context Menu")
        .font(.subheadline)
    }
    .foregroundStyle(.white)
    .padding(30)
    .background(Color.blue.cornerRadius(10))
    .contextMenu {
      Button {
        
      } label: {
        // Label is a HStack view that combines text and an image
        Label("Share", systemImage: "square.and.arrow.up")
      }
      
      Button {
        
      } label: {
        Text("Report")
      }
      
      Button {
        
      } label: {
        HStack {
          Text("Like")
          Image(systemName: "heart.fill")
        }
      }
      
    }
  }
}

#Preview {
  _6_ContextMenu()
}
