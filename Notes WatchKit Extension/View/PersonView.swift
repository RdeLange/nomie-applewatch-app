//
//  PersonView.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 11/10/2022.
//

import SwiftUI

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        .padding(-7)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.accentColor, lineWidth: 1)
        ).padding()
    }
}


struct PersonView: View {
    // MARK: - PROPERTY
    @Environment(\.presentationMode) var presentation
    @State private var text: String = ""
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var trackable: Trackable
    var key: s4eKey
    @StateObject var locationManager = LocationManager()
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    @State private var didTap:Bool = false
    
    func s4elog() async{
        var s4enote = text
        if s4enote.contains("@"+trackable.tag) {
            //do nothing
        } else {
            s4enote = "@"+trackable.tag+" "+s4enote
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
        
        text = ""
        self.presentation.wrappedValue.dismiss()
    }
    
    
    
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
                    //value = trackable.defaultvalue
                }
            HStack {
                Capsule()
                    .frame(height: 1)
            } //: HSTACK
            .foregroundColor(.accentColor)
            HStack(alignment: .center, spacing: 6) {
                TextField("What's Up?", text: $text)
                    .textFieldStyle(MyTextFieldStyle())
                
                //.buttonStyle(BorderedButtonStyle(tint: .accentColor))
            } //: HSTACK
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 6) {
                    Tag(label: "Dinner").onTapGesture {text = "Dinner with @"+trackable.tag} .frame(height: 30.0)
                    Tag(label: "Lunch").onTapGesture {text = "Lunch with @"+trackable.tag} .frame(height: 30.0)
                    Tag(label: "Meeting").onTapGesture {text = "Meeting with @"+trackable.tag} .frame(height: 30.0)
                    Tag(label: "Chat").onTapGesture {text = "Chat with @"+trackable.tag} .frame(height: 30.0)
                    Tag(label: "Workout").onTapGesture {text = "Workout with @"+trackable.tag} .frame(height: 30.0)
                    Tag(label: "Coffee").onTapGesture {text = "Coffee with @"+trackable.tag} .frame(height: 30.0)
                    
                }
                
                
                Spacer()
                // SAVE BUTTON
                HStack(){
                    Button(action: {
                        self.didTap = true
                        Task {await s4elog()}
                    }) {
                        
                        Text(didTap ? "Logging.." : "Check-In")
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 2.0)
                    .padding(.vertical, 1.0)
                    .frame(width: 100, height: 20.0)
                    .background(didTap ? Color.blue .cornerRadius( 5.0) : Color.accentColor .cornerRadius( 5.0))
                    
                }
                .padding(.top, 4.0) //: HSTACK
            }.onAppear(perform: {text = "@"+trackable.tag})
        }}
    
    struct PersonView_Previews: PreviewProvider {
        static var previews: some View {
            PersonView(trackable:Trackables2[5], key: s4eKey(s4eapi: "123",s4eurl:"www.example.com"))
        }
    }
}
