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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
        criticImageView.kf.cancelDownloadTask()
    }
    
    func setupButton() {
        criticStatusButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        criticStatusButton.layer.borderWidth = 1.0
        criticStatusButton.layer.masksToBounds = true
        criticStatusButton.layer.borderColor = #colorLiteral(red: 0.7096869946, green: 0.8863267303, blue: 0.9802721143, alpha: 1)
        criticStatusButton.layer.backgroundColor = #colorLiteral(red: 0.7096869946, green: 0.8863267303, blue: 0.9802721143, alpha: 1)
        criticStatusButton.layer.cornerRadius = 10.0
    }
    
    func configure(with item: CriticInfoICellItem) {
        //Critic name label
        criticNameLabel.text = item.criticName

        //Critic bio label
        criticBioLabel.text = item.bio

        //Critic status
        #warning("Review note 5 - fix")
        //В отличие от тайтла, добавление таргета на кнопку, а также border и прочее - это все конфигурация компонента.
        //То есть ты один раз поставить таргет и рамку и больше это не будет изменяться. Поэтому есть смысл такие
        //конфигурации проводить один раз - во время создания ячейки. В жизненном цикле ячейки для этих целей
        //отлично подходит метод awakeFromNib, который вызывается один раз, как только ячейки загружается из xib.
        //В методе configure, который вызывается из cellForRow, и может быть вызван неоднократно, есть смысл вызывать
        //только то, что может меняться, типа текста, картинки, каких-то изменений состояния и т.д.
        criticStatusButton.setTitle(item.status, for: .normal)
        

        //Critic image
        let urlTemplate = item.imageCritic
        criticImageView.kf.setImage(with: urlTemplate, placeholder: UIImage(named: "defaultImage"))
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        criticBioLabel.isHidden.toggle()
    }
    
}
