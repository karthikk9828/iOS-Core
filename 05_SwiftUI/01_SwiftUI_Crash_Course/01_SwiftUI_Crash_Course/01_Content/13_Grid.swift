//
//  13_Grid.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 26/11/25.
//

import SwiftUI

struct Fixed_GridItem: View {
  
  /*
   LazyVGrid - Vertical Grid that creates rows as needed
   LazyHGrid - Horizontal Grid that creates columns as needed
   */
  
  let columns: [GridItem] = [
    GridItem(.fixed(50)),
    GridItem(.fixed(50)),
    GridItem(.fixed(100)), // only 3rd column is 100 width
    GridItem(.fixed(50)),
    GridItem(.fixed(50))
  ]
  
  var body: some View {
    
    LazyVGrid(columns: columns) {
      ForEach(0 ..< 50) { index in
        Rectangle()
          .fill(Color.blue)
          .frame(height: 50)
      }
    }
    
  }
  
}

struct Flexible_GridItem: View {
  
  let columns: [GridItem] = [
    GridItem(.flexible()), // fit the size of the screen
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  var body: some View {
    
    LazyVGrid(columns: columns) {
      ForEach(0 ..< 50) { index in
        Rectangle()
          .fill(Color.blue)
          .frame(height: 50)
      }
    }
    
  }
  
}

struct Adaptive_GridItem: View {
  
  let columns: [GridItem] = [
    // fit as many as possible within min and max size
    GridItem(.adaptive(minimum: 50, maximum: 300)),
    GridItem(.adaptive(minimum: 150, maximum: 300))
  ]
  
  var body: some View {
    
    LazyVGrid(columns: columns) {
      ForEach(0 ..< 50) { index in
        Rectangle()
          .fill(Color.blue)
          .frame(height: 50)
      }
    }
    
  }
  
}

struct Grid_With_Sections: View {
  
  let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 6),
    GridItem(.flexible(), spacing: 6),
    GridItem(.flexible(), spacing: 6)
  ]
  
  var body: some View {
    
    ScrollView {
      
      Rectangle()
        .fill(.cyan)
        .frame(height: 200)
      
      LazyVGrid(
        columns: columns,
        alignment: .center,
        spacing: 8,
        pinnedViews: [.sectionHeaders]
      ) {
        Section {
          ForEach(0 ..< 20) { index in
            Rectangle()
              .fill(Color.blue)
              .frame(height: 150)
          }
        } header: {
          Text("Section 1")
            .font(.title)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.orange)
            .padding()
        }
        
        Section {
          ForEach(0 ..< 20) { index in
            Rectangle()
              .fill(Color.green)
              .frame(height: 150)
          }
        } header: {
          Text("Section 2")
            .font(.title)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.orange)
            .padding()
        }
        
      }
    }
    
  }
  
}

#Preview("Fixed_GridItem") {
  Fixed_GridItem()
}

#Preview("Flexible_GridItem") {
  Flexible_GridItem()
}

#Preview("Adaptive_GridItem") {
  Adaptive_GridItem()
}

#Preview("Grid_With_Sections") {
  Grid_With_Sections()
}
