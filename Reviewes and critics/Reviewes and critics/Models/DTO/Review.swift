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
    var movieName: String?
    var review: String?
    var criticName: String?
    var createData: String?
    var cover: Multimedia?
    var link: Link?
    
    
    
    enum CodingKeys: String, CodingKey {
        case movieName = "display_title"
        case review = "summary_short"
        case criticName = "byline"
        case createData = "date_updated"
        case cover = "multimedia"
        case link
    }
}
