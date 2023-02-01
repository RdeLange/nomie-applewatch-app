//
//  NoteSlider.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 30/10/2022.
//

import SwiftUI

struct PickerToggle: View {
  // MARK: - PROPERTY
    
    var displayEmoji: String = ""
    var displayName: String = "Pooped"
    var displayMin: String = "1"
    var displayMax: String = "10"
    var displayDefault: String = "1"
    @Binding var actualValue: Bool
    @State private var value: Float = 1

  // MARK: - BODY

  var body: some View {
    VStack {
      
      // SEPARATOR
        HStack {
            // Toggle
            Toggle(displayEmoji.uppercased()+" "+displayName.uppercased()+" ("+displayDefault+")", isOn: $actualValue)

                        //if toggleTrue {
                        //    actualValue = toggleTrue
                        //}
            //else {
              //  actualValue = !toggleTrue
            //}
        }//: HSTACK
      //.foregroundColor(.accentColor)
        
    }.onAppear {
        value = Float(displayDefault) ?? 1} //: VSTACK
  }
}

// MARK: - PREVIEW

//struct PickerToggle_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//        PickerToggle(displayEmoji: "💩",displayName:"Pooped",displayMin: "1",displayMax: "5",displayDefault: "3")
//        PickerToggle()
    //}
  //}
//}
