//
//  SuccessResult.swift
//  Reviewes and critics
//
//  Created by Ivan on 24.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

struct SuccessResult: Codable
{
    var reviews: [Review]
    var hasMore: Bool
    
    enum CodingKeys: String, CodingKey {
        case reviews = "results"
        case hasMore = "has_more"
    }
}
