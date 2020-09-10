//
//  CriticsCollectionViewCell.swift
//  Reviewes and critics
//
//  Created by Ivan on 28.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit
import Kingfisher

class CriticsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var criticImageView: UIImageView!
    @IBOutlet weak var criticNameLabel: UILabel!
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        criticImageView.kf.cancelDownloadTask()
    }
    
    func configure(with movie: Critic) {
        
        //Movie name tranformation
        criticNameLabel.text  = movie.criticName ?? ""
        
        //Cover tranformation
        #warning("Review note 6")
        //Раз уже мы в CriticInfoCollectionViewCell перешли к использованию CellItem, с подготовкой нужного контента
        //заранее, давай это делать для всех ячеек. Пусть эта ячейка вместо модель Critic конфигурируется моделью
        // CriticsCellItem. Чтобы не было внутри ячейки инициализации URL, как сейчас
            let urlTemplate = movie.cover?.resource?.src ?? ""
//            criticImageView.kf.setImage(with: URL(string: urlTemplate))
            criticImageView.kf.setImage(with: URL(string: urlTemplate), placeholder: UIImage(named: "defaultImage"))
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
}
