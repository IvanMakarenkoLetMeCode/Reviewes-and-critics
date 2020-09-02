//
//  UIView+Ext.swift
//  Reviewes and critics
//
//  Created by Ivan on 02.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

extension UIView {
    
    func pin(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
