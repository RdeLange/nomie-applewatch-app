//
//  InputView.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 03/10/2022.
//

import SwiftUI

struct InputView: View {
  // MARK: - PROPERTY
    @Environment(\.presentationMode) var presentation
    let trackablearray: [Trackable]
    let trackable: Trackable
    let key:s4eKey
    @StateObject var locationManager = LocationManager()
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
  
// MARK: -FUNCTION
    func s4elog() async{
        let s4enote = "#"+trackable.tag
        print(s4enote)
        guard let decoded = Data(base64Encoded: key.s4eapi) else { return }
        let s4ekey1 = String(data: decoded, encoding: .utf8)
        let s4eurl = key.s4eurl
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let logdate = dateFormatter.string(from: date)
        
        let s4elog: Log = Log(note:s4enote,api_key:s4ekey1!,key:s4ekey1!,api_url:s4eurl,lat:userLatitude,lng:userLongitude,date:logdate)
        
        print(s4elog)
        //let result = await S4ELog().sendLog(input: s4elog)
        await S4ELog().sendLog(input: s4elog)
        sleep(1)
        self.presentation.wrappedValue.dismiss()
    }
    
    func notSupported() async{
        sleep(2)
        self.presentation.wrappedValue.dismiss()
    }
    
    
  // MARK: - BODY

  var body: some View {
      HStack() {
          if trackable.type == "range" {
              RangeView(trackable:trackable,key:key)
              } else if trackable.type == "value" {
                  ValueView(trackable:trackable,key:key)
              } else if trackable.type == "timer" {
                  TimerView(trackable:trackable,key:key)
              }
                 else if trackable.type == "person" {
                PersonView(trackable:trackable,key:key)
            }
                else if trackable.type == "note" {
                    NoteView(trackable:trackable,key:key,trackablearray:trackablearray)
            }
                
                else if trackable.type == "picker" {
                    PickerView(trackable:trackable,key:key,trackablearray:trackablearray)
      }
				else if trackable.type == "habit" {
					HabitView(trackable:trackable,key:key)
}
                else if trackable.type == "tick"  {
                    Text("Logging.....").foregroundColor(.accentColor)
            }
                else if trackable.type == "tracker"  {
                    Text("Logging.....").foregroundColor(.accentColor)
                }
          else if trackable.type == "picker1" {VStack {
              Image(systemName: "exclamationmark.triangle.fill")
                  .font(.system(size: 30))
              Text("Trackables with type '"+trackable.type+"' are not supported yet.")
                  .foregroundColor(.accentColor)
                  .font(.footnote)
                  .multilineTextAlignment(.center)
          }}
          else if trackable.type == "picker1" {VStack {
              Image(systemName: "exclamationmark.triangle.fill")
                  .font(.system(size: 30))
              Text("Trackables with type '"+trackable.type+"' are not supported yet.")
                  .foregroundColor(.accentColor)
                  .font(.footnote)
                  .multilineTextAlignment(.center)
          }}
      }.onAppear(perform: {if (trackable.type == "tick") {
          Task {await s4elog()}
      }
          else if (trackable.type == "tracker") {
              Task {await s4elog()}
          }
          else if (trackable.type == "note1"){
              Task {await notSupported()}
          }
          else if (trackable.type == "picker1"){
              Task {await notSupported()}
          }
      })
  }
}

// MARK: - PREVIEW

//struct InputView_Previews: PreviewProvider {
//  static var previews: some View {
//    InputView(trackable: Trackables[1])
//  }
//}
