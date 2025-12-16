//
//  10_Spacer.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 26/11/25.
//

import SwiftUI

struct _10_Spacer: View {
  
  var body: some View {
    
    HStack {
      Rectangle()
        .fill(.orange)
        .frame(width: 100, height: 100)
        .padding(.vertical)
      
      Spacer()
        .frame(height: 10)
        .background(.red)
      
      Rectangle()
        .fill(.green)
        .frame(width: 100, height: 100)
        .padding(.vertical)
    }
    .background(.blue)
    
  }
  
}

#Preview {
  _10_Spacer()
}
