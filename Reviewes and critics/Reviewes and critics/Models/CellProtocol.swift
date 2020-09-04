//
//  CellProtocol.swift
//  Reviewes and critics
//
//  Created by Ivan on 04.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

enum VCellType {
    case header
    case reviewes
}

protocol VCellPresenting {
    var type: VCellType { get }
}
