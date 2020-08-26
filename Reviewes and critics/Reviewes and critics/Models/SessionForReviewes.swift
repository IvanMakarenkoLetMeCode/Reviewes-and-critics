//
//  SessionForReviewes.swift
//  Reviewes and critics
//
//  Created by Ivan on 24.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class SessionForReviewes {
    
    func loadGames(openingDate: String, offset: Int, order: String, query: String, completionHandler: @escaping (FullArray?, NetworkError?) -> Void) {
        
        let session = URLSession.shared
        let url = URL(string: "https://api.nytimes.com/svc/movies/v2/reviews/search.json?offset=\(offset)&opening-date=\(openingDate)&order=\(order)&query=\(query)&api-key=kAWTclAFKCoK0d646trPJ2xXyiulF5Od")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        request.setValue("a8164b4ecc5046707f37a65bf92abde1", forHTTPHeaderField: "user-key")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        if let jsonData = jsonString.data(using: .utf8) {
//            request.httpBody = jsonData
//        }
        
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
                    print(result.hasMore)
                    print (result.reviews)
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
