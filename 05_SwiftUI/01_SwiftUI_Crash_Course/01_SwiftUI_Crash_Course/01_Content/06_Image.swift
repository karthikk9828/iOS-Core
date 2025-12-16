//
//  06_Image.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 25/11/25.
//

import SwiftUI

struct _6_Image: View {
  
  var body: some View {
    
    VStack(spacing: 20) {
      
      Image(.moonKnight)
        .resizable()
        .scaledToFill()
        .frame(width: 300, height: 200)
        .clipShape(
          
          Circle()
          
          //RoundedRectangle(cornerRadius: 20)
          
          //Ellipse()
          
        )
      
      // changing color of image
      Image(.appleLogo)
        .renderingMode(.template)
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
        .foregroundStyle(.red)
      
    }
    
  }
  
}

#Preview {
  _6_Image()
}
