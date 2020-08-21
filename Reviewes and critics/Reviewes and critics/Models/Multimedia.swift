//
//  Multimedia.swift
//  Reviewes and critics
//
//  Created by Ivan on 21.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

struct Multimedia: Codable
{
    var src: String?
    
    enum CodingKeys: String, CodingKey {
        case src = "multimedia_src"
    }
}
