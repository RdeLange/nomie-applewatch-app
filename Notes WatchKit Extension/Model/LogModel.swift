//
//  LogModel.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 10/10/2022.
//

import Foundation
import SwiftUI

struct Log: Codable {
    let note: String
    let api_key: String //s4e
    let key:String //nomie6
    let api_url: String
    let lat: String
    let lng: String
    let date:String
}


class S4ELog {
    func sendLog(input: Log) async {
        let apiconnectionerror = ApiConnectionError.shared    // << here !!
        
        guard let encoded = try? JSONEncoder().encode(input) else {
            print("Failed to encode log")
            apiconnectionerror.show = true
            return
        }
        
        let url = URL(string: input.api_url)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        print("Test send log")
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // handle the result
            print(data)
            let test = (String(data: data, encoding: String.Encoding.utf8))
            if ((test?.contains("true")) != nil) {
                if ((test?.contains("true")) == true){
                    print("Successfully Logged note")
                }
                else {print("UnSuccessfully Logged note")
                    apiconnectionerror.show = true
                }
            }
            else {print("UnSuccessfully Logged note")
                apiconnectionerror.show = true
            }
            
        } catch {
            print("Logging to S4E failed")
            apiconnectionerror.show = true
            
        }
        
        
    }
}
