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
    
    func configure(with movie: Review) {
        
        //Data formatter
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
//        dateFormatter.locale = Locale(identifier: "en_US")
        
        //Movie name tranformation
        let boldText  = movie.movieName ?? ""
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        movieNameLabel.attributedText = attributedString
        
        //Data tranformation
        if movie.createData != nil
        {
            var dataMovie = movie.createData ?? ""
            var timeMovie = movie.createData ?? ""
            dataMovie.removeSubrange(dataMovie.index(dataMovie.startIndex, offsetBy: 10)..<dataMovie.endIndex)
            dataMovie.remove(at: dataMovie.index(dataMovie.startIndex, offsetBy: 4))
            dataMovie.insert("/", at: dataMovie.index(dataMovie.startIndex, offsetBy: 4))
            dataMovie.remove(at: dataMovie.index(dataMovie.startIndex, offsetBy: 7))
            dataMovie.insert("/", at: dataMovie.index(dataMovie.startIndex, offsetBy: 7))
            timeMovie.removeSubrange(timeMovie.startIndex..<timeMovie.index(dataMovie.startIndex, offsetBy: 10))
            createDataLabel.text = dataMovie
            createTimeLabel.text = timeMovie
        } else
        {
            createDataLabel.text = "No dates"
        }
        
        //Review tranformation
        if movie.review != nil
        {
            reviewLabel.text = movie.review
        } else
        {
            reviewLabel.text = "No review description"
        }
        
        //Critic name tranformation
        if movie.criticName != nil {
            
            let boldText  = movie.criticName ?? ""
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
            criticNameLabel.attributedText = attributedString
        } else {
            criticNameLabel.text = "No critic name"
        }
        
        
        //Cover tranformation
        if movie.cover?.src != nil {
            let urlTemplate = movie.cover?.src ?? ""
            movieImageView.kf.setImage(with: URL(string: urlTemplate))
        } else {
            movieImageView.image = UIImage(named: "defaultImage")
        }
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
}
