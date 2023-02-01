//
//  NoteSlider.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 30/10/2022.
//

import SwiftUI
import SwiftUI_Apple_Watch_Decimal_Pad

struct NoteValue: View {
  // MARK: - PROPERTY
    
    var displayEmoji: String = ""
    var displayName: String = "Pooped"
    var displayMin: String = "1"
    var displayMax: String = "10"
    var displayDefault: String = "1"
    @Binding var actualValue: String
    @State private var value: String = ""
    @State private var presentingModal: Bool = false
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
            DigiTextView(placeholder: "Provide Input",
                        text: $value,
                        presentingModal: presentingModal
                        )
            .onChange(of: value) { newValue in
                actualValue = value
                        }
            
        }//: HSTACK
      .foregroundColor(.accentColor)
        HStack{
            Capsule()
              .frame(height: 1)
        }.foregroundColor(.accentColor)
    }.onAppear {
        if value == "" {
            value = displayDefault
        }
        actualValue = value
    } //: VSTACK
  }
}

// MARK: - PREVIEW

//struct NoteValue_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//        NoteValue(displayEmoji: "💩",displayName:"Pooped",displayMin: "1",displayMax: "5",displayDefault: "3")
      
//        NoteValue()
//    }
//  }
//}
