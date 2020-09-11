//
//  ReviewesCellItem.swift
//  Reviewes and critics
//
//  Created by Ivan on 04.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

struct ReviewesCellItem: VCellPresenting {
    
    var type: VCellType = .reviewes
    var imageUrl: URL?
    var movieName: String?
    var filmAbout: String?
    var criticName: String?
    var date: String?
    var time: String?
    
    
}
