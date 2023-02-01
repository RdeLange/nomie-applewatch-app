//
//  Tag.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 11/10/2022.
//

import SwiftUI

struct Tag: View {
    var label:String
    //var trackable:Trackable
    var body: some View {
        
        ZStack {
                
            RoundedRectangle(cornerRadius: 45.0).fill().foregroundColor(Color.accentColor)
            RoundedRectangle(cornerRadius: 45.0).stroke().foregroundColor(Color.black)
            Text((label)).font(.system(size: 12))
                .foregroundColor(.black)
                    
        }.padding(.all, 0.0)
        }
        
}

// MARK: - PREVIEW

struct Tag_Previews: PreviewProvider {
  static var previews: some View {
      Tag(label:"Test")
    
  }
}
