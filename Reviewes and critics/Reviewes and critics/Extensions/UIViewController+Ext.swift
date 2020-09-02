//
//  UIViewController+Ext.swift
//  Reviewes and critics
//
//  Created by Ivan on 02.09.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

extension UIViewController {

    func addToParent(vc: UIViewController, to view: UIView) {
        guard let vcView = vc.view else { return }
        addChild(vc)
        view.addSubview(vcView)
        vcView.pin(to: view)
        vc.didMove(toParent: self)
    }

    func deleteVC(vc: UIViewController) {

        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()

    }

}
