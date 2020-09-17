//
//  RefreshCollectionReusableView.swift
//  Reviewes and critics
//
//  Created by Ivan on 17.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class RefreshCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func set(animated: Bool) {
        if animated {
            refreshActivityIndicator.startAnimating()
        } else {
            refreshActivityIndicator.stopAnimating()
        }
    }
    
}
