//
//  23_List.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

/*
  List
    - Similar to LazyVStack but with built-in scrolling capabilities.
 
    - LazyVStack and LazyHStack vs List
      - LazyVStack and LazyHStack loads views as they are needed, but doesn't deallocate the created views when they are off-screen.
      - List deallocates views that are off-screen to optimize memory usage.
 
    - List also has other features like swipe actions, selection, and editing capabilities.
 
    - List can be customized with different styles using the .listStyle() modifier.
*/

struct _3_List: View {
  
  @State private var fruits: [String] = [
    "Apple", "Banana", "Orange", "Mango", "Pineapple"
  ]
  
  @State private var vegetables: [String] = [
    "Carrot", "Onion", "Spinach", "Potato", "Tomato"
  ]
  
  var body: some View {
    
    NavigationView {
      List {
        Section(
          header: HStack {
            Text("Fruits")
            Image(systemName: "leaf.fill")
          }
            .font(.headline)
            .foregroundStyle(.red)
        ) {
          ForEach(fruits, id: \.self) { fruit in
            Text(fruit)
              .font(.headline)
          }
          .onDelete(perform: deleteFruit)
          .onMove(perform: moveFruit)
          .listRowBackground(Color.orange.opacity(0.3))
        }
        
        Section(
          header: HStack {
            Text("Vegetables")
            Image(systemName: "leaf.fill")
          }
            .font(.headline)
            .foregroundStyle(.red)
        ) {
          ForEach(fruits, id: \.self) { fruit in
            Text(fruit)
          }
          .listRowBackground(Color.green.opacity(0.3))
        }
      }
      .listStyle(.sidebar)
      .navigationTitle("Grocery List")
      .navigationBarItems(
        leading: EditButton(),
        trailing: Button("Add", action: add)
      )
    }
    .tint(.red)
  }
  
  private func deleteFruit(at indexSet: IndexSet) {
    fruits.remove(atOffsets: indexSet)
  }
  
  private func moveFruit(from indices: IndexSet, to destination: Int) {
    fruits.move(fromOffsets: indices, toOffset: destination)
  }
  
  func add() {
    fruits.append("Coconut")
  }
}

#Preview {
  _3_List()
}
