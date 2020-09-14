//
//  Link.swift
//  Reviewes and critics
//
//  Created by Ivan on 14.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

struct Link: Codable
{
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
