//
//  03_Color.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 25/11/25.
//

import SwiftUI
import UIKit

struct _3_Color: View {
  
  var body: some View {
    
    RoundedRectangle(cornerRadius: 25)
      .fill(
        
        //Color.primary // adapts to light/dark mode
        
        // Color(UIColor.secondarySystemBackground)
        
        Color(.app)
      )
      .frame(width: 300, height: 200)
      //.shadow(radius: 10)
      .shadow(color: .app.opacity(0.3), radius: 10, x: 20, y: 20)
    
  }
  
}

#Preview {
  _3_Color()
}
