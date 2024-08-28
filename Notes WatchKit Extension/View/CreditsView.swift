//
//  Created by Ronald de Lange
//  Nomie ⌚️ App
//

import SwiftUI

struct CreditsView: View {
  // MARK: - PROPERTY
  

  // MARK: - BODY

  var body: some View {
    VStack(spacing: 3) {
      // PROFILE IMAGE
      Image("rdl")
        .resizable()
        .scaledToFit()
        .layoutPriority(1)
      
      // HEADER
      HeaderView(title: "Credits")
      
      // CONTENT
      Text("Ronald de Lange")
        .foregroundColor(.primary)
        .fontWeight(.bold)
      
      Text("Developer")
        .font(.footnote)
        .foregroundColor(.secondary)
        .fontWeight(.light)
        
        Text("v1.0b9")
          .font(.footnote)
          .foregroundColor(.secondary)
          .fontWeight(.light)
    } //: VSTACK
  }
}

// MARK: - PREVIEW

struct CreditsView_Previews: PreviewProvider {
  static var previews: some View {
    CreditsView()
  }
}
