//
//  Resource.swift
//  Reviewes and critics
//
//  Created by Ivan on 28.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

struct Resource: Codable
{
    var resource: Multimedia?
    
    enum CodingKeys: String, CodingKey {
        case resource = "resource"
    }
}
