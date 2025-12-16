//
//  01_Text.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 25/11/25.
//

import SwiftUI

struct _1_Text: View {
  var body: some View {
    
    VStack(spacing: 20) {
      
      Text("Hello, World!")
        .font(.body) // automatically resizes based on system font settings
      //.fontWeight(.bold)
        .bold()
        .underline(color: .green)
        .italic()
        .strikethrough(color: .red)
      
      Text("Hello, World!")
        .font(.system(size: 24, weight: .medium, design: .monospaced)) // hardcoded font size will not resize when system font settings change
      
      Text("Acerbitas degenero terra aliquid accusantium allatus. Sponte ventito venustas. Voluntarius uter id aeternus delego valde adsuesco adaugeo. Caput commodo coma.")
        .multilineTextAlignment(.trailing)
      
      Text("Acerbitas degenero terra aliquid accusantium allatus. Sponte ventito venustas. Voluntarius uter id aeternus delego valde adsuesco adaugeo. Caput commodo coma.")
        .kerning(5.0) // character spacing
        .baselineOffset(10.0) // line spacing
        .multilineTextAlignment(.trailing)
      
      Text("Acerbitas degenero terra aliquid accusantium allatus. Sponte ventito venustas. Voluntarius uter id aeternus delego valde adsuesco adaugeo. Caput commodo coma.")
        .multilineTextAlignment(.leading)
        .foregroundStyle(.brown)
        .frame(width: 200, height: 100, alignment: .center)
        .minimumScaleFactor(0.1) // scales down text by 10% to fit within frame
      
      // Leading align single line text by setting alignment on frame
      Text("Hello, World!")
        .frame(width: 300, height: 100, alignment: .leading)
    }
    .padding()
    
  }
  
}

#Preview {
  _1_Text()
}
