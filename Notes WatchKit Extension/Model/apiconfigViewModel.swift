//
//  configViewModel.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 07/10/2022.
//

import Foundation
class apiconfigCall {
    func getConfig(urlinput: String!,completion:@escaping ([ApiConfig]) -> ()) {
        guard let url = URL(string: "https://"+urlinput+"/registeraw") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with:request) { (data, response, error) in
            if error != nil {
                let configerror: [ApiConfig] = [ApiConfig(apikey:"", plan: "''", privatekey: "")];
                completion(configerror)
            }
            else {
                let config = try! JSONDecoder().decode([ApiConfig].self, from: data!)
                //print(config[0].apikey)
                
                DispatchQueue.main.async {
                    completion(config)
                }}}
                    
                    .resume()
            
        
        
    }
}

