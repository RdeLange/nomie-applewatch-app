//
//  NoteSlider.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 30/10/2022.
//

import SwiftUI

struct NoteSlider: View {
  // MARK: - PROPERTY
    
    var displayEmoji: String = ""
    var displayName: String = "Pooped"
    var displayMin: String = "1"
    var displayMax: String = "10"
    var displayDefault: String = "1"
    @Binding var actualValue: String
    @State private var value: Float = 1

  // MARK: - BODY

  var body: some View {
    VStack {
      
      // SEPARATOR
      HStack {
        Capsule()
              .frame(width: 25, height: 1)
          Spacer()
          if displayEmoji != "" {
            Text(displayEmoji.uppercased())
              .font(.title3)
              .fontWeight(.bold)
              .foregroundColor(.accentColor)
              .padding(-7.0)
          }
          if displayName != "" {
            Text(displayName.uppercased())
              .font(.title3)
              .fontWeight(.bold)
              .foregroundColor(.accentColor)
              .padding(0.0)
          }
          Spacer()
          Capsule()
            .frame(width: 25, height: 1)
        
      } //: HSTACK
      .foregroundColor(.accentColor)
        HStack {
            // SLIDER
            Slider(value: Binding(get: {
              self.value
            }, set: {(newValue) in
              self.value = newValue
                actualValue = String(newValue)
            }), in: (Float(displayMin) ?? 1)!...(Float(displayMax) ?? 1)!, step: 1)
            .accentColor(.accentColor)
            Text(String(format: "%.01f", value)).frame(width:40)
        }//: HSTACK
      .foregroundColor(.accentColor)
        HStack{
            Capsule()
              .frame(height: 1)
        }.foregroundColor(.accentColor)
    }.onAppear {
        value = Float(displayDefault) ?? 1} //: VSTACK
  }
}

// MARK: - PREVIEW

//struct NoteSlider_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//        NoteSlider(displayEmoji: "💩",displayName:"Pooped",displayMin: "1",displayMax: "5",displayDefault: "3")
      
 //     NoteSlider()
 //   }
 // }
//}
