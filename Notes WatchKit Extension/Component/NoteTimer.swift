//
//  NoteSlider.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 30/10/2022.
//

import SwiftUI

struct NoteTimer: View {
  // MARK: - PROPERTY
    @State private var value: String = ""
    var columns = [
        TimerPicker.Column(label: "", options: Array(0...23).map { TimerPicker.Column.Option(text: "\($0)", tag: $0) }),
        TimerPicker.Column(label: "", options: Array(0...59).map { TimerPicker.Column.Option(text: "\($0)", tag: $0) }),
        TimerPicker.Column(label: "", options: Array(0...59).map { TimerPicker.Column.Option(text: "\($0)", tag: $0) }),
    ]
    
    @State var selection1: Int = 0
    @State var selection2: Int = 0
    @State var selection3: Int = 0 
    
    var displayEmoji: String = ""
    var displayName: String = "Pooped"
    var displayMin: String = "1"
    var displayMax: String = "10"
    var displayDefault: String = "1"
    @Binding var actualValue: String
    
    
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
        HStack{
            Text("        H").font(.custom("tmp", size: 10))
            Spacer()
            Text(":").font(.custom("tmp", size: 10))
            Spacer()
            Text("M").font(.custom("tmp", size: 10))
            Spacer()
            Text(":").font(.custom("tmp", size: 10))
            Spacer()
            Text("S        ").font(.custom("tmp", size: 10))
        }
        HStack {
            // TimePicker
            TimerPicker(columns: columns, selections: [$selection1, $selection2, $selection3]).padding(.top, -13.0).frame(height: 35)
                .onChange(of: selection1) { newValue in
                    actualValue = "\(selection1):\(selection2):\(selection3)".uppercased()
                            }
                .onChange(of: selection2) { newValue in
                    actualValue = "\(selection1):\(selection2):\(selection3)".uppercased()
                            }
                .onChange(of: selection3) { newValue in
                    actualValue = "\(selection1):\(selection2):\(selection3)".uppercased()
                            }
        }//: HSTACK
      .foregroundColor(.accentColor)
        HStack{
            Capsule()
              .frame(height: 1)
        }.foregroundColor(.accentColor)
    }.onAppear {}
         //: VSTACK
  }
}

// MARK: - PREVIEW

//struct NoteTimer_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//        NoteTimer(displayEmoji: "🧘🏾‍♀️",displayName:"Meditation",displayMin: "1",displayMax: "5",displayDefault: "3")
      
//      NoteTimer()
//    }
//  }
//}
