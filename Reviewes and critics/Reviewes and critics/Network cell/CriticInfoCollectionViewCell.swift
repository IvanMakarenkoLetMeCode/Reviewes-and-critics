//
//  CriticInfoCollectionViewCell.swift
//  Reviewes and critics
//
//  Created by Ivan on 02.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit
import Kingfisher

class CriticInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var criticImageView: UIImageView!
    @IBOutlet weak var criticNameLabel: UILabel!
    @IBOutlet weak var criticStatusButton: UIButton!
    @IBOutlet weak var criticBioLabel: UILabel!
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        criticImageView.kf.cancelDownloadTask()
    }
    
    func configure(with item: CriticInfoICellItem) {
        //Critic name label
        criticNameLabel.text = item.criticName

        //Critic bio label
        criticBioLabel.text = item.bio
//        DispatchQueue.main.async {
//
//           let bioTxt = item.bio?.convertHTMLStringToAttributed()
//            self.criticBioLabel.attributedText = bioTxt
//
//        }
//        let bioTxt = item.bio?.convertHTMLStringToAttributed()
//        bioTxt?.addAttributes([
//            .font: UIFont.systemFont(ofSize: 13),
//            .foregroundColor: UIColor.lightGray
//            ],
//                              range: NSRange(location: 0, length: item.bio?.count ?? 0))
//        criticBioLabel.attributedText = bioTxt
        //                self?.criticBioLabel.text = self?.bioTxt?.strippingHTML()

        //Critic status
        criticStatusButton.setTitle(item.status, for: .normal)
        criticStatusButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        criticStatusButton.layer.borderWidth = 1.0
        criticStatusButton.layer.masksToBounds = true
        criticStatusButton.layer.borderColor = #colorLiteral(red: 0.7096869946, green: 0.8863267303, blue: 0.9802721143, alpha: 1)
        criticStatusButton.layer.backgroundColor = #colorLiteral(red: 0.7096869946, green: 0.8863267303, blue: 0.9802721143, alpha: 1)
        //                let size = self?.criticStatusButton.frame.height
        criticStatusButton.layer.cornerRadius = 10.0

        //Critic image
        let urlTemplate = item.imageCritic
        criticImageView.kf.setImage(with: urlTemplate, placeholder: UIImage(named: "defaultImage"))
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        criticBioLabel.isHidden.toggle()
    }
    
//    override func systemLayoutSizeFitting(_ targetSize: CGSize,
//                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
//                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
//        width.constant = bounds.size.width
//        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
//    }
    
}
