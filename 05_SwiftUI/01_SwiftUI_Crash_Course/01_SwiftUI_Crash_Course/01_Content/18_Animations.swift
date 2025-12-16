//
//  18_Animations.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

/*
  Animations in SwiftUI can be done using two ways.
 
  - withAnimation block
    - wrap any state change inside withAnimation block to animate the changes.
    - any view affected by that state change will animate accordingly.
 
  - .animation() modifier
    - attach .animation() modifier to any view to animate the changes of that view based on state changes of that view.
    - only the view with the .animation() modifier will animate.
*/

struct _8_Animations_withAnimation: View {
  
  @State var isAnimated: Bool = false
  
  var body: some View {
    
    VStack {
      Button {
        withAnimation(.default) {
          isAnimated.toggle()
        }
      } label: {
        Text("Animate")
          .foregroundStyle(.white)
          .padding()
          .padding(.horizontal)
          .background(.blue)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      
      Spacer()
      
      RoundedRectangle(cornerRadius: isAnimated ? 50 : 25)
        .fill(isAnimated ? .green : .blue)
        .frame(
          width: isAnimated ? 100 : 300,
          height: isAnimated ? 100 : 300
        )
        .rotationEffect(Angle(degrees: isAnimated ? 360 : 0))
        .offset(y: isAnimated ? 300 : 0)
      
      Spacer()
    }
    .padding(.top, 32)
    
  }
}

struct _8_Animations_animation_Modifier: View {
  
  @State var isAnimated: Bool = false
  
  var body: some View {
    
    VStack {
      Button {
        isAnimated.toggle()
      } label: {
        Text("Animate")
          .foregroundStyle(.white)
          .padding()
          .padding(.horizontal)
          .background(.blue)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      
      Spacer()
      
      RoundedRectangle(cornerRadius: isAnimated ? 50 : 25)
        .fill(isAnimated ? .green : .blue)
        .frame(
          width: isAnimated ? 100 : 300,
          height: isAnimated ? 100 : 300
        )
        .rotationEffect(Angle(degrees: isAnimated ? 360 : 0))
        .offset(y: isAnimated ? 300 : 0)
        .animation(
          Animation.default.repeatForever(autoreverses: true)
        )
      
      Spacer()
    }
    .padding(.top, 32)
    
  }
}

struct _8_Animations_animation_timings: View {
  
  @State var isAnimated: Bool = false
  
  let timing: Double = 10.0
  
  var body: some View {
    
    VStack {
      Button {
        isAnimated.toggle()
      } label: {
        Text("Animate")
          .foregroundStyle(.white)
          .padding()
          .padding(.horizontal)
          .background(.blue)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      
      Spacer()
      
      // linear: constant speed from start to end
      RoundedRectangle(cornerRadius: 25)
        .fill(isAnimated ? .green : .blue)
        .frame(width: isAnimated ? 350 : 50, height: 100)
        .animation(
          Animation.linear(duration: timing)
        )
      
      // easeIn: starts slow, then speeds up
      RoundedRectangle(cornerRadius: 25)
        .fill(isAnimated ? .green : .blue)
        .frame(width: isAnimated ? 350 : 50, height: 100)
        .animation(
          Animation.easeIn(duration: timing)
        )
      
      // easeInOut: starts slow, speeds up, then slows down
      RoundedRectangle(cornerRadius: 25)
        .fill(isAnimated ? .green : .blue)
        .frame(width: isAnimated ? 350 : 50, height: 100)
        .animation(
          Animation.easeInOut(duration: timing)
        )
      
      // easeOut: starts fast, then slows down
      RoundedRectangle(cornerRadius: 25)
        .fill(isAnimated ? .green : .blue)
        .frame(width: isAnimated ? 350 : 50, height: 100)
        .animation(
          Animation.easeOut(duration: timing)
        )
      
      Spacer()
    }
    .padding(.top, 32)
    
  }
}

#Preview("withAnimation") {
  _8_Animations_withAnimation()
}

#Preview("animation_modifier") {
  _8_Animations_animation_Modifier()
}

#Preview("animation_timings") {
  _8_Animations_animation_timings()
}
