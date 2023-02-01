//
//  ModelData.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 03/10/2022.
//

import SwiftUI
import Foundation


var Trackables2: [Trackable] =  load("s4edata.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    print("test2")

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


