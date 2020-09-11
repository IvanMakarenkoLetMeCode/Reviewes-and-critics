//
//  ReviewesCollectionViewCell.swift
//  Reviewes and critics
//
//  Created by Ivan on 26.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewesCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var criticNameLabel: UILabel!
    @IBOutlet weak var createDataLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.kf.cancelDownloadTask()
    }
    
    func configure(with item: ReviewesCellItem) {
        
        //Movie name tranformation
        #warning("Review note 7 - fix")
        //Не совсем понятен смысл установки в аттрибутах просто жирного шрифта.
        //Почему просто у лейбла на xib не поставить жирный шрифт?
        movieNameLabel.text = item.movieName
        
        #warning("Review note 8 - fix")
        //Как, наверное, помнишь, целью создания CellItem помимо прочего было выведение любых трансформаций данных
        //из самой ячейки. Но тут ты делаешь все трансформации. Лучше будет все эит insert и прочее провести при
        //инициализации ReviewesCellItem, чтобы в самой ячейке у тебя была только строка
        //createTimeLabel.text = item.time и тд
        //Data tranformation
        createDataLabel.text = item.date
        createTimeLabel.text = item.time

        
        //Review tranformation
        if item.filmAbout != nil
        {
            reviewLabel.text = item.filmAbout
        } else
        {
            reviewLabel.text = "No review description"
        }
        
        //Critic name tranformation
        if item.criticName != nil {
            
            let boldText  = item.criticName ?? ""
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
            criticNameLabel.attributedText = attributedString
        } else {
            criticNameLabel.text = "No critic name"
        }
        
        
        //Cover tranformation
        let urlTemplate = item.imageUrl
        movieImageView.kf.setImage(with: urlTemplate, placeholder: UIImage(named: "defaultImage"))
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
}
