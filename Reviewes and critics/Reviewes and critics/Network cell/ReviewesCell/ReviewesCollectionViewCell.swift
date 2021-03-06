//
//  ReviewesCollectionViewCell.swift
//  Reviewes and critics
//
//  Created by Ivan on 26.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit
import Kingfisher

protocol ReviewesCollectionViewCellDelegate {
    func shareButtonTouchUpIns(_ cell: ReviewesCollectionViewCell)
}

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
    
    var delegate: ReviewesCollectionViewCellDelegate?
    
    @IBAction func shareClick(_ sender: Any) {
        delegate?.shareButtonTouchUpIns(self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.kf.cancelDownloadTask()
    }
    
    func configure(with item: ReviewesCellItem) {
        
        //Movie name tranformation
        movieNameLabel.text = item.movieName
        
        //Data tranformation
        createDataLabel.text = item.date

        
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
