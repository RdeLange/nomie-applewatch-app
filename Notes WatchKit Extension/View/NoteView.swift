//
//  NoteView.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 30/10/2022.
//

import SwiftUI

struct ComboTrackable: Codable {
    let displayEmoji: String
    let displayName: String
    let displayMin: String
    let displayMax: String
    let displayDefault: String
    let tag: String
    let type: String
    
}


struct NoteView: View {
    @Environment(\.presentationMode) var presentation
    var trackable: Trackable
    var key: s4eKey
    var trackablearray: [Trackable]
    @State private var ComboTrackablesArray: [ComboTrackable] = [ComboTrackable]()
    @State private var didTap:Bool = false
    @State var values: [String] = []
    @State var initiated = false
    @StateObject var locationManager = LocationManager()
    var userLatitude: String {
            return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        }
        
    var userLongitude: String {
            return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
        }
    
    func load() async {
        if !initiated {
            print("Load function PLACEHOLDER")
            let components = trackable.note.components(separatedBy: " ")
            print(components)
            let regex = "\\((.*?)\\)"
            //var ComboTrackables : [ComboTrackable] = []
            for component in components {
            let valuearray = matchesForRegexInText(regex: regex, text: component)
            var value : String = ""
            if valuearray.count > 0 {
                value = valuearray[0]
                value = value.replacingOccurrences(of: "(",with: "")
                value = value.replacingOccurrences(of: ")",with: "")}
            else {
                value = "" }
            //var tag = component.replacingOccurrences(of: "\\s?\\([\\w\\s]*\\)", with: "", options: .regularExpression)
            var tag = component.replacingOccurrences(of: regex, with: "", options: .regularExpression)
            tag = tag.replacingOccurrences(of: "#",with: "")
            
            print(tag, "->", value)
            if let idx = trackablearray.firstIndex(where: { $0.tag == tag })
                { if trackablearray[idx].type == "tick" {
                    if value == "" {
                        value = "1"
                    }
                }
                let combo : ComboTrackable = ComboTrackable(displayEmoji: trackablearray[idx].emoji, displayName: trackablearray[idx].label, displayMin: trackablearray[idx].min, displayMax: trackablearray[idx].max, displayDefault: value, tag: trackablearray[idx].tag,type:trackablearray[idx].type)
                ComboTrackablesArray.append(combo)
                values.append(value)}
        }
        print(ComboTrackablesArray)
    initiated = true}
    }
    
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {

    do {

        let regex = try NSRegularExpression(pattern: regex, options: [])
        let nsString = text as NSString

        let results = regex.matches(in: text,
                                            options: [], range: NSMakeRange(0, nsString.length))
        return results.map { nsString.substring(with: $0.range)}

    } catch let error as NSError {

        print("invalid regex: \(error.localizedDescription)")

        return []
    }}
    
    func s4elog() async{
        var s4enote = "#"+trackable.tag+" "
        for (index, trackable) in ComboTrackablesArray.enumerated() {
            s4enote = s4enote + "#"+trackable.tag+"("+values[index]+") "
            
        }
    
        
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
    
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "flowchart.fill")
                    .font(.system(size: 30))
                
                Text("Collecting info from Combo Trackers")
                    .font(.footnote)
                .multilineTextAlignment(.center)}
            
            ScrollView {
                
                // loop trough combotrackables
                ForEach(0..<ComboTrackablesArray.count, id: \.self) { i in
                    if ComboTrackablesArray[i].type == "range" {
                        HStack{
                            NoteSlider(displayEmoji: ComboTrackablesArray[i].displayEmoji,displayName:ComboTrackablesArray[i].displayName,displayMin: ComboTrackablesArray[i].displayMin,displayMax: ComboTrackablesArray[i].displayMax,displayDefault: ComboTrackablesArray[i].displayDefault, actualValue: $values[i])
                        }}
                    else if ComboTrackablesArray[i].type == "value" {
                        HStack{
                            NoteValue(displayEmoji: ComboTrackablesArray[i].displayEmoji,displayName:ComboTrackablesArray[i].displayName,displayMin: ComboTrackablesArray[i].displayMin,displayMax: ComboTrackablesArray[i].displayMax,displayDefault: ComboTrackablesArray[i].displayDefault, actualValue: $values[i])
                        }}
                    else if ComboTrackablesArray[i].type == "tick" {
                        HStack{
                            NoteValue(displayEmoji: ComboTrackablesArray[i].displayEmoji,displayName:ComboTrackablesArray[i].displayName,displayMin: ComboTrackablesArray[i].displayMin,displayMax: ComboTrackablesArray[i].displayMax,displayDefault: ComboTrackablesArray[i].displayDefault, actualValue: $values[i])
                        }}
                    else if ComboTrackablesArray[i].type == "timer" {
                        HStack{
                            NoteTimer(displayEmoji: ComboTrackablesArray[i].displayEmoji,displayName:ComboTrackablesArray[i].displayName,displayMin: ComboTrackablesArray[i].displayMin,displayMax: ComboTrackablesArray[i].displayMax,displayDefault: ComboTrackablesArray[i].displayDefault,actualValue: $values[i])
                        }}
                    else {
                        HStack{
                        Capsule()
                            .frame(width: 25, height: 1)
                        Spacer()
                            if ComboTrackablesArray[i].displayEmoji != "" {
                                Text(ComboTrackablesArray[i].displayEmoji.uppercased())
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                                .padding(-7.0)
                        }
                            if ComboTrackablesArray[i].displayName != "" {
                                Text(ComboTrackablesArray[i].displayName.uppercased())
                                .foregroundColor(.accentColor)
                                .padding(0.0)
                        }
                        Spacer()
                        Capsule()
                            .frame(width: 25, height: 1)
                        
                    } //: HSTACK
                        .foregroundColor(.accentColor)
                    HStack {Text("Input not Possible")}.foregroundColor(.accentColor)
                        HStack{
                            Capsule()
                              .frame(height: 1)
                        }.foregroundColor(.accentColor)
                    }
                    Spacer()}
                        
                // Button
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
                .padding(.top, 6.0) //: HSTACK
                    }
                    
                
                
            }
        .onAppear(perform: {
            Task {
                    await load()
                }
        })
        .opacity(0.8)
    }
}

//struct NoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteView()
//    }
//}
