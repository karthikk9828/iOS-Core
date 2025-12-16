//
//  24_Alert.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

/*
  Alert
    - presented using .alert() modifier, similar to .sheet()
*/

struct _4_Alert: View {
  
  @State private var showAlert = false
  @State private var backgroundColor = Color.green.opacity(0.1)
  
  var body: some View {
    
    ZStack {
      backgroundColor.ignoresSafeArea()
      
      Button("Show Alert") {
        showAlert.toggle()
      }
      .alert(isPresented: $showAlert) {
        alert
      }
    }

  }
  
  var alert: Alert {
    Alert(
      title: Text("Delete File"),
      message: Text("Are you sure you want to delete this file? This action cannot be undone."),
      primaryButton: .destructive(Text("Delete"), action: {
        backgroundColor = .red.opacity(0.1)
      }),
      secondaryButton: .cancel()
    )
  }
}

#Preview {
  _4_Alert()
}
