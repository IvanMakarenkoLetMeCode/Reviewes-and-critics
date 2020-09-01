//
//  ViewController.swift
//  Reviewes and critics
//
//  Created by Ivan on 21.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var backgroungSCView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var reviewesViewController: ReviewesViewController!
    var criticsViewController: CriticsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureReviewesViewController()
        
    }
    
    func configureReviewesViewController() {
        reviewesViewController = ReviewesViewController()
        addChild(reviewesViewController)
        view.addSubview(reviewesViewController.view)
        reviewesViewController.didMove(toParent: self)
    }
    
}
