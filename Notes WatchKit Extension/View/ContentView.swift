//
//  Created by Ronald de Lange
//  Nomie ⌚️ App
//

import SwiftUI


struct ContentView: View {
  // MARK: - PROPERTY
    @EnvironmentObject var apiconnectionerror: ApiConnectionError
    @State private var text: String = ""
    let timer = Timer.publish(every: 70, on: .main, in: .common).autoconnect()
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var isCreditsPresented: Bool = false
    @State private var isSettingsPresented: Bool = false
    //@State private var Trackables : [Trackable] = [Trackable]()
    @State private var Trackables: [Trackable] = [Trackable]()
    @State private var s4ekey: s4eKey = s4eKey(s4eapi: "not yet loaded",s4eurl:"not yet loaded")
    @StateObject var locationManager = LocationManager()
    var userLatitude: String {
            return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        }
        
    var userLongitude: String {
            return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
        }
  
  
  // MARK: - FUNCTION
  
  func getDocumentDirectory() -> URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path[0]
  }
    
    func s4elog() async{
        let s4enote = text
        
        guard let decoded = Data(base64Encoded: s4ekey.s4eapi) else { return }
        let s4ekey1 = String(data: decoded, encoding: .utf8)
        let s4eurl = s4ekey.s4eurl
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let logdate = dateFormatter.string(from: date)
        
        let s4elog: Log = Log(note:s4enote,api_key:s4ekey1!,key:s4ekey1!,api_url:s4eurl,lat:userLatitude,lng:userLongitude,date:logdate)
        
        print(s4elog)
        await S4ELog().sendLog(input: s4elog)
        
        text = ""
    }
    
    
  
  func save() {
    // dump(trackables)
    
    do {
      // 1. Convert the notes array to data using JSONEncoder
      let data = try JSONEncoder().encode(Trackables)
      
      // 2. Create a new URL to save the file using the getDocumentDirectory
      let url = getDocumentDirectory().appendingPathComponent("trackables")
      
      // 3. Write the data to the given URL
      try data.write(to: url)
   } catch {
     print("Saving trackable data has failed!")
    }
  }
    
    func save_s4ekey() {
      // dump(s4ekey)
      
      do {
        // 1. Convert the notes array to data using JSONEncoder
        let data = try JSONEncoder().encode(s4ekey)
        
        // 2. Create a new URL to save the file using the getDocumentDirectory
        let url = getDocumentDirectory().appendingPathComponent("s4ekey")
        
        // 3. Write the data to the given URL
        try data.write(to: url)
     } catch {
       print("Saving s4ekey has failed!")
      }
    }
  
    func load() async {
      var dataModel: [Trackable]?
      @AppStorage("serverUrl") var serverUrl: String = "";
      @AppStorage("apiKey") var apiKey: String = "";
      @AppStorage("privateKey") var privateKey: String = "";
      
        if (apiKey != ""){
            
            let encodedprivatekey = privateKey.data(using: .utf8)?.base64EncodedString() ?? "no private key"
            
            let s4ekeys : KeysApi! = KeysApi(key:Keys(api_key: apiKey, private_key: encodedprivatekey))
            
            guard let encoded = try? JSONEncoder().encode(s4ekeys) else {
                print("Failed to encode keyscombination")
                return
                
            }
            //print(s4ekeys)
            
            let url = URL(string: "https://" + serverUrl + "/awgettrackables")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            print("Test")
            print(apiKey)
            
            
            do {
                let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
                // handle the result
                dataModel = try JSONDecoder().decode([Trackable].self, from: data)
                Trackables = dataModel!
                //print(String(data: data, encoding: String.Encoding.utf8))
                print(Trackables)
                // now save to staorage
                save()
            } catch {
                print("Loading from API failed, loading from storage")
                loadfromstorage()
            }
            
        }
        else {print("AW APIKEY not available")}
  }
    
    func load_s4ekey() async {
      var dataModel: s4eKey?
      @AppStorage("serverUrl") var serverUrl: String = "";
      @AppStorage("apiKey") var apiKey: String = "";
      @AppStorage("privateKey") var privateKey: String = "";
      
        if (apiKey != ""){
            
            let encodedprivatekey = privateKey.data(using: .utf8)?.base64EncodedString() ?? "no private key"
            
            let s4ekeys : KeysApi! = KeysApi(key:Keys(api_key: apiKey, private_key: encodedprivatekey))
            
            guard let encoded = try? JSONEncoder().encode(s4ekeys) else {
                print("Failed to encode keyscombination")
                return
                
            }
            //print(s4ekeys)
            
            let url = URL(string: "https://" + serverUrl + "/awgets4eapi")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            print("Test s4ekey")
            
            
            
            do {
                let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
                // handle the result
                dataModel = try JSONDecoder().decode(s4eKey.self, from: data)
                s4ekey = dataModel!
                guard let decoded = Data(base64Encoded: s4ekey.s4eapi) else { return }
                let decodedstring = String(data: decoded, encoding: .utf8)
                
                print("S4EKEY:")
                print(s4ekey.s4eapi)
                print("S4EKEY decoded:")
                print(decodedstring!)
                print("S4EKEY url:")
                print(s4ekey.s4eurl)
                // now save to staorage
                save_s4ekey()
            } catch {
                print("S4E Key Loading from API failed, loading from storage")
                loadfromstorage_s4ekey()
            }
        }
        else {print("AW APIKEY not available")
            //apiconnectionerror.show = true
        }

  }
    
    func loadfromstorage() {
        DispatchQueue.main.async {
          do {
            // 1. Get the notes URL path
            let url = getDocumentDirectory().appendingPathComponent("trackables")
            
            // 2. Create a new property for the data
            let data = try Data(contentsOf: url)
            
            // 3. Decode the data
          Trackables = try JSONDecoder().decode([Trackable].self, from: data)
          } catch {
              apiconnectionerror.show = true
          }
        }
      }
    
    func loadfromstorage_s4ekey() {
        print("try load s4ekey from dtorage")
        DispatchQueue.main.async {
          do {
            // 1. Get the notes URL path
            let url = getDocumentDirectory().appendingPathComponent("s4ekey")
            
            // 2. Create a new property for the data
            let data = try Data(contentsOf: url)
            
            // 3. Decode the data
          s4ekey = try JSONDecoder().decode(s4eKey.self, from: data)
              print("loaded s4ekey from storage:")
              print(s4ekey)
          } catch {
            // Do nothing
              print("loadromstoragr => failed to decode")
              s4ekey = s4eKey(s4eapi: "s4ekey not available",s4eurl: "s4ekey not available")
              apiconnectionerror.show = true
          }
        }
      }
  
  func delete(offsets: IndexSet) {
    withAnimation {
      //notes.remove(atOffsets: offsets)
      save()
    }
  }

  // MARK: - BODY
  
  var body: some View {
    VStack {
      HStack(alignment: .center, spacing: 6) {
        TextField("What's Up?", text: $text)
        
        Button {
          // 1. Only run the button's action when the text field is not empty
          guard text.isEmpty == false else { return }
            Task {await s4elog()}
          
          
        } label: {
            Image(systemName:"arrow.up.circle")
                .font(.system(size: 42, weight: .semibold))
        }
        .fixedSize()
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.green)
        //.buttonStyle(BorderedButtonStyle(tint: .accentColor))
      } //: HSTACK
      
      Spacer()
      
        if Trackables.count >= 1 {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 2) {ForEach(0..<Trackables.count, id: \.self) { i in
                    if !Trackables[i].type.contains("_blacklisted"){
                        NavigationLink(destination: InputView(trackablearray: Trackables, trackable: Trackables[i],key: s4ekey)) {
                        TrackableButton(emoji:Trackables[i].emoji,label:Trackables[i].label).padding(.all, 0.0) .frame(width: 35.0, height: 35.0)
                    }
                }
                }}
                
            }} else {
        Spacer()
        Image(systemName: "note.text")
          .resizable()
          .scaledToFit()
          .foregroundColor(.gray)
          .opacity(0.25)
          .padding(25)
        Spacer()
      } //: LIST
        
        
    } //: VSTACK
    //.navigationTitle("Trackables")
    .onReceive(timer, perform: { _ in
        print("Update Data")
        Task {
                await load_s4ekey()
            }
        Task {
                await load()
            }
              })
    .onAppear(perform: {
        Task {
                await load_s4ekey()
            }
        Task {
                await load()
            }
    })
    .fullScreenCover(isPresented: $apiconnectionerror.show) {
        ConnectErrorModal(isPresented: $apiconnectionerror.show)}
  }
}

// MARK: - PREVIEW

//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//  }
//}
