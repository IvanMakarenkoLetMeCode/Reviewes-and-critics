//
//  SessionForCritics.swift
//  Reviewes and critics
//
//  Created by Ivan on 28.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class SessionForCritics {
    
    func loadCritics(reviewer: String, completionHandler: @escaping (Critics?, NetworkError?) -> Void) {
        
        let session = URLSession.shared
        let apiKey = Constants()
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nytimes.com"
        components.path = "/svc/movies/v2/critics/\(reviewer).json?"
        components.queryItems = [
            URLQueryItem(name: "api-key", value: apiKey.apiKey)
        ]
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 200
            
            if statusCode != 200 {
                completionHandler(nil, .requestError)
                return
            }
            do {
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let result = try decoder.decode(Critics.self, from: data)
//                    print (result.critics)
                    completionHandler(result, nil)
                } else {
                    completionHandler(nil, .requestError)
                }
            } catch {
                completionHandler(nil, .parseError)
            }
        }
        
        task.resume()
    }
}
