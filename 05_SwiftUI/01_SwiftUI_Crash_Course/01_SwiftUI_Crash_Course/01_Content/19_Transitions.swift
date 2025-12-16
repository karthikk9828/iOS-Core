//
//  19_Transitions.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

/*
  Animations
    - Used when view is already on the screen and we want to animate changes to its properties.
 
  Transitions
    - Used when view is being added or removed from the
*/

struct _9_Transitions: View {
  
  @State var showView: Bool = false
  
  var body: some View {
    
    ZStack(alignment: .bottom) {
      VStack {
        Button {
          showView.toggle()
        } label: {
          Text(showView ? "Hide" : "Show")
            .foregroundStyle(.white)
            .padding()
            .padding(.horizontal)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
        Spacer()
      }
      
      if showView {
        RoundedRectangle(cornerRadius: 30)
          .frame(height: UIScreen.main.bounds.height / 2)
//          .transition(.slide)
//          .transition(AnyTransition.opacity.animation(.easeInOut))
          .transition(.move(edge: .bottom))
          .animation(.spring)
      }
    }
    .ignoresSafeArea()
    .padding(.top, 50)
    
  }
}

#Preview {
  _9_Transitions()
}
