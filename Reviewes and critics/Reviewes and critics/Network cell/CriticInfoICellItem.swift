//
//  CriticInfoICellItem.swift
//  Reviewes and critics
//
//  Created by Ivan on 04.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

#warning("Review note 4")
//Опять же для чистоты структуры проекта, лучше группировать файлы, относящие к одной ячейке внутри одной папки.
//Например, создай папку с именем CriticInfoICell, и внутри нее будут CriticInfoICellItem,
//CriticInfoCollectionViewCell.swift и CriticInfoCollectionViewCell.xib. И так со всеми ячейками

struct CriticInfoICellItem: VCellPresenting {
    
    var type: VCellType = .header
    var criticName: String?
    var imageCritic: URL?
    var status: String?
    var bio: String?
}
