//
//  SessionForReviewes.swift
//  Reviewes and critics
//
//  Created by Ivan on 24.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class SessionForReviewes {
    
    func loadReviewes(openingDate: String, offset: Int, order: String, query: String, completionHandler: @escaping (FullArray?, NetworkError?) -> Void) {
        
        let session = URLSession.shared
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        #warning("Review note 2")
        //Не очень круто в запросе иметь пустые аргументы (как тут, в случае, если ничего не ввели в поиске, то будет:
        //&query=&api-key=kAWTcl...). Лучше и openingDate и query передать в виде опционалов.
        //И добавлять их к запросу, только если они не nil и не isEmpty.
        //А еще лучше попробуй урл формировать посредством URLQueryItems. Он круче тем, что добавляет необходимую
        //кодировку (типа %20 вместо пробела). На твой выбор.
        guard let url = URL(string: "https://api.nytimes.com/svc/movies/v2/reviews/search.json?offset=\(offset)&opening-date=\(openingDate)&order=\(order)&query=\(text ?? "")&api-key=kAWTclAFKCoK0d646trPJ2xXyiulF5Od") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        #warning("Review note 3")
        //Старайся удалять закомментированный код, если он не будет использован
        
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
