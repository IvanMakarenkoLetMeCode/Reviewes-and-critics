//
//  Review.swift
//  Reviewes and critics
//
//  Created by Ivan on 21.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

struct Review: Codable
{
    var movieName = String
    var review = String?
    var criticName = String
    var createData = String
    var createTime = <#value#>
    var cover = Multimedia
    
    
    
    enum CodingKeys: String, CodingKey {
        case movieName = "display_title"
        case review = "summary_short"
        case criticName = "byline"
        case createData = "publication_date"
        case createTime
        case cover
    }
}
