//
//  27_TextField.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

struct _7_TextField: View {
  
  @State private var textFieldInput: String = ""
  @State private var data: [String] = []
  
  var body: some View {
    
    NavigationView {
      VStack {
        TextField("Type something here...", text: $textFieldInput)
          .padding()
          .background(Color.gray.opacity(0.2).cornerRadius(10))
          .foregroundStyle(.red)
          .font(.headline)
        
        Button {
          if isValidText() {
            saveText()
          }
        } label: {
          Text("Save")
            .padding()
            .frame(maxWidth: .infinity)
            .background(
              isValidText() ? Color.blue.cornerRadius(10) : Color.gray.cornerRadius(10)
            )
            .foregroundStyle(.white)
            .font(.headline)
        }
        .disabled(isValidText() == false)
        
        ForEach(data, id: \.self) { item in
          Text(item)
        }
        
        Spacer()
      }
      .padding()
      .navigationTitle("TextField Example")
    }
    
  }
  
  private func isValidText() -> Bool {
    return textFieldInput.count >= 3
  }
  
  private func saveText() {
    data.append(textFieldInput)
    textFieldInput = ""
  }
}

#Preview {
  _7_TextField()
}
