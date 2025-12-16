//
//  21_Sheet_Animation_Transtion.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

/*
  We can resent a second screen using 3 ways
    - sheet
    - animation
    - transtion
*/

// Present a second screen using Sheet
struct SecondScreen_Using_Sheet: View {
  
  @State var showScreen: Bool = false
  
  var body: some View {
    
    ZStack {
      Color.orange.ignoresSafeArea()
      
      VStack {
        ShowScreenButton(showScreen: $showScreen)
          .sheet(isPresented: $showScreen) {
            AnotherScreen1()
          }
        
        Spacer()
      }
      .padding(.top, 60)
    }
    
  }
}

// Present a second screen using Transition
struct SecondScreen_Using_Transition: View {
  
  @State var showScreen: Bool = false
  
  var body: some View {
    
    ZStack {
      Color.orange.ignoresSafeArea()
      
      VStack {
        ShowScreenButton(showScreen: $showScreen)
        
        Spacer()
      }
      .padding(.top, 60)
      
      ZStack {
        if showScreen {
          AnotherScreen2(showScreen: $showScreen)
            .padding(.top, 24)
            .transition(.move(edge: .bottom))
            .animation(.spring)
        }
      }
      .zIndex(2.0) // add zIndex with ZStack to get dismissing transition working properly
    }
    
  }
}

// Present a second screen using Animation
struct SecondScreen_Using_Animation: View {
  
  @State var showScreen: Bool = false
  
  var body: some View {
    
    ZStack {
      Color.orange.ignoresSafeArea()
      
      VStack {
        ShowScreenButton(showScreen: $showScreen)
        
        Spacer()
      }
      .padding(.top, 60)
      
      AnotherScreen2(showScreen: $showScreen)
        .padding(.top, 24)
        .offset(y: showScreen ? 0 : UIScreen.main.bounds.height)
        .animation(.spring)
    }
    
  }
}

struct ShowScreenButton: View {
  @Binding var showScreen: Bool
  
  var body: some View {
    Button {
      showScreen.toggle()
    } label: {
      Text("Show Screen")
        .foregroundStyle(.orange)
        .font(.headline)
        .padding(20)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
}

struct AnotherScreen1: View {
  @Environment(\.dismiss) var dismiss
  
  @Binding var showScreen: Bool?
  
  init(showScreen: Binding<Bool?> = .constant(nil)) {
    self._showScreen = showScreen
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.blue.ignoresSafeArea()
      
      Button {
        if showScreen != nil {
          showScreen?.toggle()
        } else {
          dismiss()
        }
      } label: {
        Image(systemName: "xmark")
          .foregroundStyle(.white)
          .font(.largeTitle)
          .padding(20)
      }
    }
  }
}

struct AnotherScreen2: View {
  @Binding var showScreen: Bool

  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.blue.ignoresSafeArea()
      
      Button {
        showScreen.toggle()
      } label: {
        Image(systemName: "xmark")
          .foregroundStyle(.white)
          .font(.largeTitle)
          .padding(20)
      }
    }
  }
}

#Preview("SecondScreen_Using_Sheet") {
  SecondScreen_Using_Sheet()
}

#Preview("SecondScreen_Using_Transition") {
  SecondScreen_Using_Transition()
}

#Preview("SecondScreen_Using_Animation") {
  SecondScreen_Using_Animation()
}


