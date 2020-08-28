//
//  Critics.swift
//  Reviewes and critics
//
//  Created by Ivan on 28.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

struct Critics: Codable
{
    var critics: [Critic]
    
    enum CodingKeys: String, CodingKey {
        case critics = "results"
    }
}
