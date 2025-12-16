//
//  22_NavigationView_NavigationLink.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

/*
  NavigationView:
    - A container that manages a stack of views for navigation.
    - Never embed NavigationView inside another NavigationView, we only need one.
    - We can easily add a navigation bar and title.
 
  NavigationLink
    - A view that creates a button to navigate to a destination view.
    - must be used inside a NavigationView.
*/

struct _2_NavigationView_NavigationLink: View {
  
  var body: some View {
    
    NavigationView {
      ScrollView {
        
        NavigationLink("Hello world") {
          _SecondScreen()
        }
        
        Text("Hello world")
        Text("Hello world")
        Text("Hello world")
      }
      .navigationTitle("NavigationView") // it should be iniside the NavigationView
      .navigationBarTitleDisplayMode(.automatic)
//      .toolbar(.hidden)
    }
    
  }
}

struct _SecondScreen: View {
  
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.brown.opacity(0.2).ignoresSafeArea()
        .navigationTitle("Second Screen")
        .toolbar(.hidden) // hide navigationbar and add custom backbutton
      
      VStack {
        Button {
          dismiss()
        } label: {
          HStack {
            Image(systemName: "chevron.left")
              .font(.headline)
            Text("Back")
          }
        }
        
        NavigationLink("Third Screen") {
          _ThirdScreen()
        }
      }
    }
  }
}

struct _ThirdScreen: View {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.yellow.opacity(0.2).ignoresSafeArea()
        .navigationTitle("Third Screen")
        .navigationBarItems(
          leading: HStack {
            Image(systemName: "person.fill")
            Image(systemName: "flame.fill")
          },
          trailing: NavigationLink {
            Text("Settings Screen")
          } label: {
            Image(systemName: "gear")
          }
        )
    }
  }
}

#Preview {
  _2_NavigationView_NavigationLink()
}
