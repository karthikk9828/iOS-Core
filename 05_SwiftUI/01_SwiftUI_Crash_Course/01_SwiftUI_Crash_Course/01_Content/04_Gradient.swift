//
//  04_Gradient.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 25/11/25.
//

import SwiftUI

struct _4_Gradient: View {
  
  var body: some View {
    
    RoundedRectangle(cornerRadius: 25)
      .fill(
        
//        .blue
        
//        LinearGradient(
//          gradient: Gradient(colors: [.blue, .red]),
//          startPoint: .topLeading,
//          endPoint: .bottomTrailing
//        )
        
//        RadialGradient(
//          gradient: Gradient(colors: [.blue, .red]),
//          center: .center,
//          startRadius: 5,
//          endRadius: 200
//        )
        
        AngularGradient(
          gradient: Gradient(colors: [.red, .blue]),
          center: .topLeading,
          angle: .degrees(180 + 45)
        )
        
      )
      .frame(width: 300, height: 200)
    
  }
  
}

#Preview {
  _4_Gradient()
}
