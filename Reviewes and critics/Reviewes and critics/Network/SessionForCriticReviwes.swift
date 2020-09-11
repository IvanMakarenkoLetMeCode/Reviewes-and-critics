//
//  SessionForCriticReviwes.swift
//  Reviewes and critics
//
//  Created by Ivan on 31.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class SessionForCriticReviwes {
    
    func loadReviewes(offset: Int?, reviewer: String?, completionHandler: @escaping (FullArray?, NetworkError?) -> Void) {
        
        let session = URLSession.shared
        let apiKey = Constants()
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nytimes.com"
        components.path = "/svc/movies/v2/reviews/search.json?"
        var queryItems = [
            URLQueryItem(name: "api-key", value: apiKey.apiKey),
            URLQueryItem(name: "reviewer", value: reviewer),
        ]
        if let offsetKey = offset, offsetKey != 0 {
            queryItems.append(URLQueryItem(name: "offset", value: String(offsetKey)))
        }
        components.queryItems = queryItems
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
                    let result = try decoder.decode(FullArray.self, from: data)
//                    print(result.hasMore)
//                    print (result.reviews)
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
