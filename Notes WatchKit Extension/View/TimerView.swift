//
//  TimerView.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 04/10/2022.
//
import SwiftUI

struct TimerView: View {
  // MARK: - PROPERTY
    @Environment(\.presentationMode) var presentation
  @State private var value: String = ""
    var trackable: Trackable
    var columns = [
        TimerPicker.Column(label: "", options: Array(0...23).map { TimerPicker.Column.Option(text: "\($0)", tag: $0) }),
        TimerPicker.Column(label: "", options: Array(0...59).map { TimerPicker.Column.Option(text: "\($0)", tag: $0) }),
        TimerPicker.Column(label: "", options: Array(0...59).map { TimerPicker.Column.Option(text: "\($0)", tag: $0) }),
    ]
    
    @State var selection1: Int = 0
    @State var selection2: Int = 0
    @State var selection3: Int = 0
    var key: s4eKey
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
    
    func s4elog() async{
        let s4enote = "#"+trackable.tag+"("+String(selection1)+":"+String(selection2)+":"+String(selection3)+")"
        
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
          HStack {
            Capsule()
              .frame(height: 1)
          } //: HSTACK
          .foregroundColor(.accentColor)
      // ACTUAL LINE COUNT
      Text("Value: \(selection1):\(selection2):\(selection3)".uppercased())
        .fontWeight(.bold)
      
      // Timerpicker
          TimerPicker(columns: columns, selections: [$selection1, $selection2, $selection3]).padding(.top, -13.0).frame(height: 70)
      // CANCEL/SAVE BUTTON
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

//struct TimerView_Previews: PreviewProvider {
//  static var previews: some View {
//      TimerView(trackable:Trackables[4])
//  }
//}
