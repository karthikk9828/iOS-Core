//
//  05_Icon.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 25/11/25.
//

import SwiftUI

struct _5_Icon: View {
  
  var body: some View {
    
    Image(systemName: "person.fill.badge.plus")
      .renderingMode(.original)
      .resizable()
      .scaledToFit()
      .frame(width: 200, height: 200)
//      .foregroundColor(.blue)
    
  }
  
}

#Preview {
  _5_Icon()
}
