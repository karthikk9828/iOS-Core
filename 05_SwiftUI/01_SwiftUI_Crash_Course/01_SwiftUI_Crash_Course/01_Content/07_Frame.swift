//
//  07_Frame.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 26/11/25.
//

import SwiftUI

struct _7_Frame: View {
  
  var body: some View {
    
    // default frame wraps the content size
    Text("Hello, World!")
      .background(.green)
    
    Text("Hello, World!")
      .background(.green)
      .frame(width: 200, height: 300, alignment: .center)
      .background(.blue)
    
    Text("Hello, World!")
      .background(.green)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(.blue)
    
    Text("Hello, World!")
      .background(.green)
      .frame(height: 100)
      .background(.orange)
      .frame(width: 150)
      .background(.cyan)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(.blue)
      .frame(height: 300)
      .background(.yellow)
    
  }
  
}

#Preview {
  _7_Frame()
}
