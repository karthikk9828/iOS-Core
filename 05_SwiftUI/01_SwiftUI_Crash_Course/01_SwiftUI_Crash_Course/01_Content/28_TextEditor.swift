//
//  28_TextEditor.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 10/12/25.
//

import SwiftUI

/*
 TextEditor
   - Text field with multiple lines support
 */

struct _8_TextEditor: View {
  
  @State private var textEditorText: String = "This is a sample text in TextEditor. You can edit this text. TextEditor supports multiple lines of text input. You can use it for notes, comments, or any other multi-line text input needs."
  
  @State var savedText: String = ""
  
  var body: some View {
    
    NavigationView {
      VStack {
        TextEditor(text: $textEditorText)
          .frame(height: 250)
        Button {
          savedText = textEditorText
        } label: {
          Text("Save")
            .font(.headline)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.blue)
            .cornerRadius(10)
        }
        
        Text(savedText)
        
        Spacer()
      }
      .padding()
      .navigationTitle("TextEditor Example")
    }
    
  }
}

#Preview {
  _8_TextEditor()
}
