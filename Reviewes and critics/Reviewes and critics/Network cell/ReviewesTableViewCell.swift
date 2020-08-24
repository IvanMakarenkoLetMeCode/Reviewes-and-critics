//
//  ReviewesTableViewCell.swift
//  Reviewes and critics
//
//  Created by Ivan on 21.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var criticName: UILabel!
    @IBOutlet weak var createData: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with review: Results) {
        
        //Data formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        //Movie name tranformation
        movieName.text = review.review[]
        
        //Data tranformation
//        if game.releaseDates != nil
//        {
//           gameYearLabel.text = game.releaseDates?.compactMap { $0.date }.map { Date(timeIntervalSince1970: Double($0)) }.compactMap { dateFormatter.string(from: $0) }.joined(separator: "\r")
//        } else
//        {
//            gameYearLabel.text = "No release\rdates"
//        }
        
        //Review tranformation
        if review.review != nil
        {
            reviewLabel.text = review.review
        } else
        {
            reviewLabel.text = "No review description"
        }
        
        //Critic name tranformation
        criticName.text = review.criticName
        
        //Cover tranformation
//        if let id = game.cover?.imageId {
//            let urlTemplate = "https://images.igdb.com/igdb/image/upload/t_cover_big/\(id).jpg"
//            gameImageView.kf.setImage(with: URL(string: urlTemplate))
//        } else {
//            gameImageView.image = UIImage(named: "defaultImage")
//        }
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
