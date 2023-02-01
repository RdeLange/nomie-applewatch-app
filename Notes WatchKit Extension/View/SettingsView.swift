//
//  Created by Ronald de Lange
//  Nomie ⌚️ App
//

import SwiftUI

struct ApiSettings: Codable {
    let apikey: String
    let plan: String
    let privatekey: String
    let success: Int
}



struct SettingsView: View {
    // MARK: - PROPERTY
    @EnvironmentObject var apiconnectionerror: ApiConnectionError
    @AppStorage("apiKey") var apiKey: String = "";
    @AppStorage("privateKey") var privateKey: String = "";
    @State private var value: Float = 1.0
    @State var apiconfig: [ApiConfig] = []
    @State private var isPresentingRegisterModal = false
    @State private var isPresentingUnRegisterModal = false
    
    // MARK: - FUNCTION
    
    func update() {
        // lineCount = Int(value)
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 8) {
            // HEADER
            HeaderView(title: "⌚️API Config")
            // API
            
            HStack(){
                Text("Key:")
                TextField("AW API Key", text: $apiKey)
            }
            
            
            HStack(){
                
                Button("Remove") {
                    print("Remove API registration")
                    isPresentingUnRegisterModal.toggle()
                }.buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 2.0)
                    .padding(.vertical, 1.0)
                    .frame(width: 75, height: 25.0)
                    .background(
                        Color.red
                            .cornerRadius( 5.0))
                    .fullScreenCover(isPresented: $isPresentingUnRegisterModal) {
                        UnRegisterModal(isPresented: $isPresentingUnRegisterModal)}
                
                Button("Register") {
                    print("Register API")
                    isPresentingRegisterModal.toggle()
                    //Task {
                    //        await registerAPI()
                    //    }
                }.buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 2.0)
                    .padding(.vertical, 1.0)
                    .frame(width: 75, height: 25.0)
                    .background(
                        Color.accentColor
                            .cornerRadius( 5.0))
                    .fullScreenCover(isPresented: $isPresentingRegisterModal) {
                        RegisterModal(isPresented: $isPresentingRegisterModal)}
            }
            .padding(.top, 4.0) //: HSTACK
            
            
        } //: VSTACK
        .fullScreenCover(isPresented: $apiconnectionerror.show) {
            ConnectErrorModal(isPresented: $apiconnectionerror.show)}
    

        
    }
    
    
    // MARK: - PREVIEW
    
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
}
