//
//  CriticInfoICellItem.swift
//  Reviewes and critics
//
//  Created by Ivan on 04.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

struct CriticInfoICellItem: VCellPresenting {
    
    var type: VCellType = .header
    var criticName: String?
    var imageCritic: URL?
    var status: String?
    var bio: NSAttributedString?
    var bioHidden: Bool = false
}
