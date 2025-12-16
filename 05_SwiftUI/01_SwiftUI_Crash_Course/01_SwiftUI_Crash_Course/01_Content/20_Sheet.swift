//
//  20_Sheet.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

/*
  .sheet
    - Used to present a modal view
    - Can only present be used once in a view hierarchy
    - If we add multiple sheets, only the first one will be considered
 
  .fullScreenCover
    - Used to present a modal view in full screen
*/

struct _0_Sheet: View {
  
  @State var showSheet: Bool = false
  
  var body: some View {
    
    ZStack {
      Color.green.ignoresSafeArea()
      
      Button {
        showSheet.toggle()
      } label: {
        Text("Show Sheet")
          .foregroundStyle(.green)
          .font(.headline)
          .padding(20)
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .sheet(isPresented: $showSheet) {
        SecondScreen()
      }
      
    }
  }
}

struct _0_Sheet_FullScreenCover: View {
  
  @State var showSheet: Bool = false
  
  var body: some View {
    
    ZStack {
      Color.green.ignoresSafeArea()
      
      Button {
        showSheet.toggle()
      } label: {
        Text("Show Sheet")
          .foregroundStyle(.green)
          .font(.headline)
          .padding(20)
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .fullScreenCover(isPresented: $showSheet) {
        SecondScreen()
      }
      
    }
  }
}

struct SecondScreen: View {
  
//  @Environment(\.presentationMode) var presentationMode
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.blue.ignoresSafeArea()
      
      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark")
          .foregroundStyle(.white)
          .font(.largeTitle)
          .padding(20)
      }
    }
  }
}

#Preview(".sheet") {
  _0_Sheet()
}

#Preview(".fullScreenCover") {
  _0_Sheet_FullScreenCover()
}
