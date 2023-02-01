//
//  Trackable.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 03/10/2022.
//

import Foundation

struct Trackable: Identifiable, Decodable, Encodable {
    var id: String
    var tag: String
    var type: String
    var color: String
    var emoji: String
    var label: String
    var include: String
    var uom: String
    var max: String
    var min: String
    var defaultvalue: String
    var note: String
    var picks: String
}

class ApiConnectionError: ObservableObject {
    
    static let shared = ApiConnectionError()
    @Published var show = false
    
}
