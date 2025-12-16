//
//  29_Toggle.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

struct _9_Toggle: View {
  
  @State private var isOn: Bool = true
  
  var body: some View {
    
    Toggle(isOn: $isOn) {
      Text("Notifications")
    }
    .tint(.red)
    .padding()
    
  }
}

#Preview {
  _9_Toggle()
}
