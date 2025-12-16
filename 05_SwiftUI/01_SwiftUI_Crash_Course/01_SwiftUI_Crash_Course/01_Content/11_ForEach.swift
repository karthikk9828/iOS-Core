//
//  11_ForEach.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 26/11/25.
//

import SwiftUI

struct _1_ForEach: View {
  
  var body: some View {
    
    let data: [String] = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    
    VStack {
      ForEach(0 ..< 5) { index in
        HStack {
          Circle()
            .fill(.blue)
            .frame(width: 30, height: 30)
          Text("Item \(index)")
        }
      }
      
      Divider()
      
      ForEach(data, id: \.self) { item in
        HStack {
          Circle()
            .fill(.blue)
            .frame(width: 30, height: 30)
          Text(item)
        }
      }
      
    }
    
  }
  
}

#Preview {
  _1_ForEach()
}
