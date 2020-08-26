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
    @IBOutlet weak var shareButton: UIButton!
    
    
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
        movieNameLabel.text = movie.movieName
        
        //Data tranformation
        if movie.createData != nil
        {
//            gameYearLabel.text = game.releaseDates?.compactMap { $0.date }.map { Date(timeIntervalSince1970: Double($0)) }.compactMap { dateFormatter.string(from: $0) }.joined(separator: "\r")
            createDataLabel.text = movie.createData
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
            criticNameLabel.text = movie.criticName
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
}
