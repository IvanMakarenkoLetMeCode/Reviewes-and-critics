//
//  Critic.swift
//  Reviewes and critics
//
//  Created by Ivan on 28.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

struct Critic: Codable
{
    var criticName: String?
    var cover: Resource?
    
    
    
    enum CodingKeys: String, CodingKey {
        case criticName = "display_name"
        case cover = "multimedia"
    }
}
