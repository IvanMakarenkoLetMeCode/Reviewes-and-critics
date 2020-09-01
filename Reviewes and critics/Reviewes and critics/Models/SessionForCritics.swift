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
        let text = reviewer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: "https://api.nytimes.com/svc/movies/v2/critics/\(text ?? "").json?api-key=kAWTclAFKCoK0d646trPJ2xXyiulF5Od") else { return }
        
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

//extension Data {
//    var html2AttributedString: NSAttributedString? {
//        do {
//            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            print("error:", error)
//            return  nil
//        }
//    }
//    var html2String: String { html2AttributedString?.string ?? "" }
//}
//
//extension StringProtocol {
//    var html2AttributedString: NSAttributedString? {
//        Data(utf8).html2AttributedString
//    }
//    var html2String: String {
//        html2AttributedString?.string ?? ""
//    }
//}
