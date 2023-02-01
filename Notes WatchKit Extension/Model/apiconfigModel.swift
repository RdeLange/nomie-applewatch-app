//
//  apiModel.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 07/10/2022.
//

import SwiftUI

struct ApiConfig: Codable, Identifiable {
    let id = UUID()
    let apikey: String
    let plan: String
    let privatekey: String
}

struct Keys: Codable {
    var api_key: String
    var private_key: String
}

struct KeysApi: Codable {
    var key: Keys
}

struct s4eKey: Codable {
    var s4eapi : String
    var s4eurl : String
}
