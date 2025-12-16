//
//  09_Stack.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 26/11/25.
//

import SwiftUI

struct _VStack: View {
  
  var body: some View {
    
    VStack(alignment: .leading, spacing: 0) {
      Rectangle()
        .fill(.blue)
        .frame(width: 200, height: 100)
      Rectangle()
        .fill(.green)
        .frame(width: 150, height: 100)
      Rectangle()
        .fill(.orange)
        .frame(width: 100, height: 100)
    }
    
  }
}

struct _HStack: View {
  
  var body: some View {
    
    HStack(alignment: .bottom, spacing: 0) {
      Rectangle()
        .fill(.blue)
        .frame(width: 200, height: 200)
      Rectangle()
        .fill(.green)
        .frame(width: 150, height: 150)
      Rectangle()
        .fill(.orange)
        .frame(width: 100, height: 100)
    }
    
  }
}

struct _ZStack: View {
  
  var body: some View {
    
    ZStack(alignment: .bottomTrailing) {
      Rectangle()
        .fill(.blue)
        .frame(width: 200, height: 200)
      Rectangle()
        .fill(.green)
        .frame(width: 150, height: 150)
      Rectangle()
        .fill(.orange)
        .frame(width: 100, height: 100)
    }
    
  }
}

#Preview {
  _VStack()
}

#Preview {
  _HStack()
}

#Preview {
  _ZStack()
}
