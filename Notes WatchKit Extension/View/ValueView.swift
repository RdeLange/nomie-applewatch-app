//
//  ValueView.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 03/10/2022.
//

import SwiftUI
import CoreLocation



struct ValueView: View {
  // MARK: - PROPERTY
    @Environment(\.presentationMode) var presentation
    var trackable: Trackable
    var key: s4eKey
    @State var value: String = ""
    @StateObject var locationManager = LocationManager()
    var userLatitude: String {
            return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        }
        
    var userLongitude: String {
            return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
        }
    @State private var didTap:Bool = false
   
  
  // MARK: - FUNCTION

  func update() {
      print( Int(value) as Any)
  }
    
    func getDocumentDirectory() -> URL {
      let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return path[0]
    }
    
    func s4elog() async{
        let s4enote = "#"+trackable.tag+"("+value+")"
        
        guard let decoded = Data(base64Encoded: key.s4eapi) else { return }
        let s4ekey1 = String(data: decoded, encoding: .utf8)
        let s4eurl = key.s4eurl
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let logdate = dateFormatter.string(from: date)
        
        let s4elog: Log = Log(note:s4enote,api_key:s4ekey1!,key:s4ekey1!,api_url:s4eurl,lat:userLatitude,lng:userLongitude,date:logdate)
        
        print(s4elog)
        await S4ELog().sendLog(input: s4elog)
        self.presentation.wrappedValue.dismiss()
    }
    
    
    
  // MARK: - BODY

  var body: some View {
      
          
    
      VStack(spacing: 3) {
      // HEADER
       // HeaderView(title: (trackable.emoji)+(trackable.label))
          Text( (trackable.emoji)+(trackable.label))
              
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.accentColor)
            .padding(-2.0)
            .onAppear {
                value = trackable.defaultvalue
                if (value == "undefined") {
                    value=""}
            }
          HStack {
            Capsule()
              .frame(height: 1)
          } //: HSTACK
          .foregroundColor(.accentColor)
      // ACTUAL LINE COUNT
      Text("Value: \(value)".uppercased())
        .fontWeight(.bold)
      
      // Keypad
          Keypad(keypadtext:$value)
      // SAVE BUTTON
        HStack(){
            Button(action: {
                    self.didTap = true
                Task {await s4elog()}
                }) {

                Text(didTap ? "Logging.." : "Save")
                    
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 2.0)
                .padding(.vertical, 1.0)
                .frame(width: 100, height: 25.0)
                    .background(didTap ? Color.blue .cornerRadius( 5.0) : Color.accentColor .cornerRadius( 5.0))
            
        }
        .padding(.top, 4.0) //: HSTACK
    } //: VSTACK
  }
}

// MARK: - PREVIEW

//struct ValueView_Previews: PreviewProvider {
//  static var previews: some View {
//      ValueView(trackable:Trackables[4])
//  }
//}
