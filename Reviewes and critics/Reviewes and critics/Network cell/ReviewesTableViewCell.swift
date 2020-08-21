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
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var criticName: UILabel!
    @IBOutlet weak var createData: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with game: Game) {
        
        //Data formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        //Name tranformation
        gameNameLabel.text = game.name
        
        //Data tranformation
        if game.releaseDates != nil
        {
           gameYearLabel.text = game.releaseDates?.compactMap { $0.date }.map { Date(timeIntervalSince1970: Double($0)) }.compactMap { dateFormatter.string(from: $0) }.joined(separator: "\r")
        } else
        {
            gameYearLabel.text = "No release\rdates"
        }
        
        //Genre tranformation
        if game.genres != nil
        {
            gameGenresLabel.text = game.genres?.compactMap { $0.name }.joined(separator: ", ")
        } else
        {
            print("")
            gameGenresLabel.text = "No genre\rdescription"
        }
        
        //Platform tranformation
        if game.platforms != nil
        {
            gamePlatformLabel.text = game.platforms?.compactMap { $0.abbreviation }.joined(separator: ", ")
        } else
        {
            gamePlatformLabel.text = "No platform"
        }
        
        gamePlatformLabel.layer.backgroundColor = UIColor.lightGray.cgColor
        gamePlatformLabel.layer.borderWidth = 1.0
        gamePlatformLabel.layer.borderColor = UIColor.black.cgColor
        gamePlatformLabel.layer.masksToBounds = true
        
        
        //Raiting tranformation
        if game.totalRating != nil
        {
            var roundedRating = game.totalRating ?? 0
            roundedRating = (roundedRating * 100).rounded() / 100
            if roundedRating < 30 {
                gameRateLabel.layer.backgroundColor = UIColor.red.cgColor
            }
            if roundedRating >= 30 && roundedRating < 70 {
                gameRateLabel.layer.backgroundColor = UIColor.yellow.cgColor
            }
            if roundedRating >= 70 {
                gameRateLabel.layer.backgroundColor = UIColor.green.cgColor
            }
            gameRateLabel.text = String(roundedRating)
        } else
        {
            gameRateLabel.text = "-"
            gameRateLabel.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        gameRateLabel.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        DispatchQueue.main.async {
            let size = self.gameRateLabel.frame.height
            self.gameRateLabel.layer.cornerRadius = size / 2
            self.gameRateLabel.layer.borderWidth = 1.0
            self.gameRateLabel.layer.masksToBounds = true
            self.gameRateLabel.layer.borderColor = UIColor.black.cgColor
        }
        
        
        //Cover tranformation
        if let id = game.cover?.imageId {
            let urlTemplate = "https://images.igdb.com/igdb/image/upload/t_cover_big/\(id).jpg"
            gameImageView.kf.setImage(with: URL(string: urlTemplate))
        } else {
            gameImageView.image = UIImage(named: "defaultImage")
        }
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
