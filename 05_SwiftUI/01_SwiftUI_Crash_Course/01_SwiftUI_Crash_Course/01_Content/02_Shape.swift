//
//  02_Shapes.swift
//  01_SwiftUI_Crash_Course
//
//  Created by Karthik K on 25/11/25.
//

import SwiftUI

struct _2_Shapes_Circle: View {
  
  var body: some View {
    
    VStack(spacing: 20) {
      
      Circle()
        .fill(.blue)

      Circle()
        .stroke(.red, lineWidth: 4)
      
      Circle()
        .stroke(
          .green,
          style: StrokeStyle(
            lineWidth: 10,
            lineCap: .butt,
            dash: [4]
          )
        )
      
      Circle()
        .trim(from: 0.2, to: 1.0)
      
      Circle()
        .trim(from: 0.2, to: 1.0)
        .stroke(.purple, lineWidth: 5)
      
    }
    .padding()
    
  }
  
}

struct _2_Shapes_Ellipse: View {
  
  var body: some View {
    
    VStack(spacing: 40) {
      
      Ellipse()
        .fill(.blue)
        .frame(width: 200, height: 100)
      
      Ellipse()
        .stroke(Color.red, lineWidth: 4)
        .frame(width: 200, height: 100)
      
      Ellipse()
        .stroke(
          .green,
          style: StrokeStyle(
            lineWidth: 10,
            lineCap: .butt,
            dash: [4]
          )
        )
        .frame(width: 200, height: 100)
      
      Ellipse()
        .trim(from: 0.2, to: 1.0)
        .frame(width: 200, height: 100)
      
      Ellipse()
        .trim(from: 0.2, to: 1.0)
        .stroke(.purple, lineWidth: 5)
        .frame(width: 200, height: 100)
      
    }
    .padding()
    
  }
  
}

struct _2_Shapes_Capsule: View {
  
  var body: some View {
    
    VStack(spacing: 40) {
      
      Capsule(style: .circular)
        .fill(.blue)
        .frame(width: 200, height: 100)
      
      Capsule()
        .stroke(Color.red, lineWidth: 4)
        .frame(width: 200, height: 100)
      
      Capsule()
        .stroke(
          .green,
          style: StrokeStyle(
            lineWidth: 10,
            lineCap: .butt,
            dash: [4]
          )
        )
        .frame(width: 200, height: 100)
      
      Capsule()
        .trim(from: 0.2, to: 1.0)
        .frame(width: 200, height: 100)
      
      Capsule()
        .trim(from: 0.2, to: 1.0)
        .stroke(.purple, lineWidth: 5)
        .frame(width: 200, height: 100)
      
    }
    .padding()
    
  }
  
}

struct _2_Shapes_Rectangle: View {
  
  var body: some View {
    
    VStack(spacing: 30) {
      
      Rectangle()
        .fill(.blue)
        .frame(width: 200, height: 100)
      
      RoundedRectangle(cornerRadius: 25)
        .fill(.green)
        .frame(width: 200, height: 100)
      
      Rectangle()
        .stroke(Color.red, lineWidth: 4)
        .frame(width: 200, height: 100)
      
      Rectangle()
        .stroke(
          .green,
          style: StrokeStyle(
            lineWidth: 10,
            lineCap: .butt,
            dash: [4]
          )
        )
        .frame(width: 200, height: 100)
      
      Rectangle()
        .trim(from: 0.4, to: 1.0)
        .frame(width: 200, height: 100)
      
    }
    .padding()
    
  }
  
}

#Preview {
  _2_Shapes_Circle()
}

#Preview {
  _2_Shapes_Ellipse()
}

#Preview {
  _2_Shapes_Capsule()
}

#Preview {
  _2_Shapes_Rectangle()
}
