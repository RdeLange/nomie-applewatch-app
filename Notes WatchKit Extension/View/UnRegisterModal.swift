//
//  UnRegisterModal.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 11/10/2022.
//

import SwiftUI

struct UnregisterResults: Codable {
    let results: String
    let success: Bool
}

struct UnRegisterModal: View {
    // MARK: - PROPERTY
    @EnvironmentObject var apiconnectionerror: ApiConnectionError
    @Binding var isPresented: Bool
    @AppStorage("serverUrl") var serverUrl: String = "";
    @AppStorage("apiKey") var apiKey: String = "";
    @AppStorage("privateKey") var privateKey: String = "";
    @State var apiconfig: [ApiConfig] = []
    @State private var didTap:Bool = false
    
    // MARK: - FUNCTION
    
    func unregisterAPI() async {
      
      
      let encodedprivatekey = privateKey.data(using: .utf8)?.base64EncodedString() ?? "no private key"
      
      let s4ekeys : KeysApi! = KeysApi(key:Keys(api_key: apiKey, private_key: encodedprivatekey))
      
      guard let encoded = try? JSONEncoder().encode(s4ekeys) else {
          print("Failed to encode keyscombination")
          return
          
      }
      
        let url = URL(string: "https://" + serverUrl + "/awunregister")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
      
      print("About to unregister following apiKey:")
      print(apiKey)
      
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // handle the result
            let Result:UnregisterResults = try JSONDecoder().decode(UnregisterResults.self, from: data)
          print(Result)
            if(Result.success == true){
                apiKey = ""
                privateKey = ""
                print("Unregister Successful")
            }
            else {print("Unregister Failed")
                apiconnectionerror.show = true
            }
        } catch {
            print("Unregister Failed")
            apiconnectionerror.show = true
          }
        
        
        
  }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            Image(systemName: "key.icloud")
                .font(.system(size: 30))

            Text("UnRegister the API key will delete your server registration. Please Confirm")
                .font(.footnote)
                .multilineTextAlignment(.center)
            Button(action: {
                    self.didTap = true
                Task {await unregisterAPI()}
                isPresented.toggle()
                }) {

                Text(didTap ? "Please Wait.." : "Unregister")
                    
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 2.0)
                .padding(.vertical, 1.0)
                .frame(width: 100, height: 25.0)
                    .background(didTap ? Color.blue .cornerRadius( 5.0) : Color.accentColor .cornerRadius( 5.0))
            
        }
        .opacity(0.8)
        .padding(10)

    

        
    }
}

struct UnRegisterTestView: View {
    @State private var isPresentingUnRegisterModal = false
    
    var body: some View {
        Button("Connect") {
            isPresentingUnRegisterModal.toggle()
        }
        .fullScreenCover(isPresented: $isPresentingUnRegisterModal) {
            UnRegisterModal(isPresented: $isPresentingUnRegisterModal)
        }
    }
}

struct UnRegisterTestView_Previews: PreviewProvider {
    static var previews: some View {
        UnRegisterTestView()
    }
}
