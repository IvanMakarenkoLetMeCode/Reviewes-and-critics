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
        if movie.cover?.resource?.src != nil {
            let urlTemplate = movie.cover?.resource?.src ?? ""
            criticImageView.kf.setImage(with: URL(string: urlTemplate))
        } else {
            criticImageView.image = UIImage(named: "defaultImage")
        }
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
}
