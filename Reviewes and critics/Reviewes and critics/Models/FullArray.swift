//
//  FullArray.swift
//  Reviewes and critics
//
//  Created by Ivan on 25.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

struct FullArray: Codable
{
    var reviews: [Review]
    var hasMore: Bool
    
    enum CodingKeys: String, CodingKey {
        case reviews = "results"
        case hasMore = "has_more"
    }
}
