//
//  RegisterModel.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 11/10/2022.
//

import SwiftUI

struct RegisterModal: View {
    // MARK: - PROPERTY
    @EnvironmentObject var apiconnectionerror: ApiConnectionError
    @Binding var isPresented: Bool
    @AppStorage("serverUrl") var serverUrl: String = "";
    @AppStorage("apiKey") var apiKey: String = "";
    @AppStorage("privateKey") var privateKey: String = "";
    @State var apiconfig: [ApiConfig] = [];
    @State private var didTap:Bool = false
    @State var tempurl: String = "awapi.dailynomie.com";
    
    // MARK: - FUNCTION
    
    func registerAPI() async {
        await unregisterAPI();
        if (tempurl != ""){
                serverUrl = tempurl;}
        if (serverUrl == ""){
                serverUrl = "awapi.dailynomie.com";}
        
        apiconfigCall().getConfig(urlinput: serverUrl) { (apiconfig) in

        self.apiconfig = apiconfig
            apiKey = apiconfig[0].apikey
            privateKey = apiconfig[0].privatekey
            //apiKey = "t81NGkS7Zl1rVcS36KVUhjBGGqD5ynKC"
            //privateKey = "-----BEGIN PRIVATE KEY----- MYvyY2Ql9ZvfejuqB0Q2Wgnc28WtQSkVRxYhUqSvFsBGh6MSFKbZa1mlKvXVtStsFppLMUSJG7gtjMVm9ESU1yobU7bedyGC20DR58Xja8f8ZzMpAGYOQHy472DwxczJr1lWQOLBYfJ5pPv06eaiRvMAtm74h2dbnzqZXWZzDOldihjyAOAI4GtJnXcWhVdTsf38svpZ5LzdbgHV9HLsUGL7fCo9pb6pDKjN24di6xS9u8kWinyZ9NabmQzXK5ARRI3hkVlAxLFkElLFTOH5CTSfNRVqtRKVLhNQ72V3BoEYcGJnLqHeVKwmVg8vcgS3K1J1eeViO5FqiyRhGq5L35fvLbfsoSMHkBFGemTEnIVD5WPL2vdLGWWVtu1l72QR3Xy0OeABo8ztRoebMSSszCrGMJ2aJ1DZIoFBDyURkxEB21PrRN4t4W8qiqsZXWchKOkjBo -----END PRIVATE KEY-----"
            //apiKey = ""
            //privateKey = ""
            if (apiKey == ""){
                apiconnectionerror.show = true
            }
            print(apiKey)
            print(privateKey)
        }
        
        
        
    }
    
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
                //apiconnectionerror.show = true
            }
        } catch {
            print("Unregister Failed")
            //apiconnectionerror.show = true
          }
        
        
        
  }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            Image(systemName: "key.icloud")
                .font(.system(size: 30))

            Text("Register new API key will delete all existing keys. Please Confirm")
                .font(.footnote)
                .multilineTextAlignment(.center)
            Text("Url:")
                .frame(height: 25.0)
            TextField("AW Server Domain", text: $tempurl)
                .frame(height: 25.0)
            Button(action: {
                    self.didTap = true
                Task {await registerAPI()}
                isPresented.toggle()
                }) {

                Text(didTap ? "Please Wait.." : "Register")
                    
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

struct TestView: View {
    @State private var isPresentingRegisterModal = false
    
    var body: some View {
        Button("Connect") {
            isPresentingRegisterModal.toggle()
        }
        .fullScreenCover(isPresented: $isPresentingRegisterModal) {
            RegisterModal(isPresented: $isPresentingRegisterModal)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
