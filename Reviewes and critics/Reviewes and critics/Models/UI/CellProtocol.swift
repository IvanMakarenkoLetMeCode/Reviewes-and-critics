//
//  CellProtocol.swift
//  Reviewes and critics
//
//  Created by Ivan on 04.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import Foundation

#warning("Review note 1 - fix")
//Для более чистой структуры проекта нужно группировать модели по их назначению.
//Например, данная модель VCellType относится к слою UI. Поэтому для нее лучше создать отдельную подпапку внутри Models
//с именем UI. Туда же пойдут всякие тулбары и прочее.
//Модели типа Multimedia, Review и тд, т.е., что отражает модели JSON лучше поместить в подпапку DTO (расшифровывается
//как Data Transfer Objects, т.е. все модели, связанные с сериализацией JSON).
//Модели типа SessionForReviews и тд лучше вообще вынести в отдельную группу Network (не подпапку), т.к. это не модель,
//а сервис для выполнения запросов.
enum VCellType {
    case header
    case reviewes
}

protocol VCellPresenting {
    var type: VCellType { get }
}
