//
//  SessionForReviewes.swift
//  Reviewes and critics
//
//  Created by Ivan on 24.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class SessionForReviewes {
    
    func loadReviewes(typeRequest: String, openingDate: String?, offset: Int?, order: String, query: String?, completionHandler: @escaping (FullArray?, NetworkError?) -> Void) {
        
        let session = URLSession.shared
        let apiKey = Constants()
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nytimes.com"
        components.path = "/svc/movies/v2/reviews/\(typeRequest).json?"
        var queryItems = [
            URLQueryItem(name: "api-key", value: apiKey.apiKey),
            URLQueryItem(name: "order", value: order)
        ]
        if let date = openingDate, !date.isEmpty {
            queryItems.append(URLQueryItem(name: "opening-date", value: date))
        }
        if let queryKey = query, !queryKey.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: queryKey))
        }
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
