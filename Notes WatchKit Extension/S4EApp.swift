//
//  Created by Ronald de Lange
//  Nomie ⌚️ App
//

import SwiftUI

@main
struct S4EApp: App {
    @StateObject var apiconnectionerror = ApiConnectionError.shared
    var body: some Scene {
    WindowGroup {
        // These Views will end up in pages.
              TabView {
                  NavigationView {
                      ContentView()
                          .environmentObject(apiconnectionerror)
                  }
                SettingsView()
                      .environmentObject(apiconnectionerror)
                CreditsView()
                      .environmentObject(apiconnectionerror)
              }
              .tabViewStyle(PageTabViewStyle())
        
        //  NavigationView {
    //    ContentView()
    //  }
    }
  }
}
