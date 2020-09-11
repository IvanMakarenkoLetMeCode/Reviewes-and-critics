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
        #warning("Review note 2 - fix")
        //Не очень круто в запросе иметь пустые аргументы (как тут, в случае, если ничего не ввели в поиске, то будет:
        //&query=&api-key=kAWTcl...). Лучше и openingDate и query передать в виде опционалов.
        //И добавлять их к запросу, только если они не nil и не isEmpty.
        //А еще лучше попробуй урл формировать посредством URLQueryItems. Он круче тем, что добавляет необходимую
        //кодировку (типа %20 вместо пробела). На твой выбор.
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
        #warning("Review note 3 - fix")
        //Старайся удалять закомментированный код, если он не будет использован

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
