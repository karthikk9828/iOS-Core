//
//  25_ActionSheet.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

struct _5_ActionSheet: View {
  
  @State private var showActionSheet = false
  
  var body: some View {
    
    VStack {
      HStack {
        Circle()
          .frame(width: 30, height: 30)
        Text("@username")
        Spacer()

        Button {
          showActionSheet.toggle()
        } label: {
          Image(systemName: "ellipsis")
        }
        .tint(.primary)
      }
      
      Rectangle()
        .aspectRatio(1.0, contentMode: .fit)
    }
    .padding(.horizontal, 8)
    .actionSheet(isPresented: $showActionSheet) {
      actionSheet
    }
    
  }
  
  var actionSheet: ActionSheet {
    
    let button1: ActionSheet.Button = .default(Text("Default"))
    let button2: ActionSheet.Button = .destructive(Text("Destructive"))
    let button3: ActionSheet.Button = .cancel()
      
    return ActionSheet(
      title: Text("This is the title"),
      message: Text("This is the message"),
      buttons: [
        button1, button2, button3
      ]
    )
  }
}

#Preview {
  _5_ActionSheet()
}
