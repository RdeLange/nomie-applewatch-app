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
            //apiKey = "wDhycMSgU8cNUzEPkLnU5lxzuNtWgx4X"
            //privateKey = "-----BEGIN PRIVATE KEY----- dbrEW2eSE9N4nyNvxeIrUJ75J7dFRtFeVtwLV6C08ZhYkR98eUdrxhdiMpLjXlAyY5sLj2qwmTPHmXiWsauyUHfUF0BrjEbq2dLR3tqGw7c9Wn2pHkvwxxOnSh881Kurrtk4jloZXJnwI3bq4G1TZqDryhORiRQcRoBAqd3ImkaAuwapbjQd9gz8SB2KIt8KCNcGzuAGh9OuMd0qzWOl7eCg5ZhXSQ6JfFtJwvdUZzJYRki4GdkwWeCVDF3sD2lYYd3ppwuq8FYd1ogVIHmYHMuCDcrF3XJUp5JqJjnVZrjiULkZItC6v5HsFnIN2me3QTkubQEdQM7Qlk925k3fMIQZyc5i135LrMVOdAp9vAiirj0UftYd00c6hoypZ3Hp2iwSxXv49uxnblWKfLJQGcOCYwUOHYdAPdhS66LD9xw8RYyFea8jwvKiXxRvOuXQYFJZlO -----END PRIVATE KEY-----"
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
