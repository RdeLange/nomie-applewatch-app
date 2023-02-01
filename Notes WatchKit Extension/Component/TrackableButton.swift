//
//  TrackableButton.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 03/10/2022.
//


import SwiftUI

struct TrackableButton: View {
    var emoji:String
    var label:String
    //var trackable:Trackable
    var body: some View {
        
        ZStack {
                
            RoundedRectangle(cornerRadius: 10.0).fill().foregroundColor(Color.accentColor)
            RoundedRectangle(cornerRadius: 10.0).stroke().foregroundColor(Color.black)
                    Text((emoji)).font(.system(size: 30))
                    VStack {
                        Spacer()
                        Text((label)).font(.system(size: 10))
                            .foregroundColor(.black)
                        
                    }
        }.padding(.all, -9.0)
        }
        
}

// MARK: - PREVIEW

struct TrackableButton_Previews: PreviewProvider {
  static var previews: some View {
      TrackableButton(emoji:"👍",label:"Test")
    
  }
}
