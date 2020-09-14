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
    @IBOutlet weak var containerView: UIView!
    
    var reviewesViewController: ReviewesViewController?
    var criticsViewController: CriticsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onSegmentChanged(segmentedControl)
    }
    
    func configureReviewesViewController() {
        reviewesViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewesViewController") as? ReviewesViewController
        addToParent(vc: reviewesViewController!, to: containerView)
    }
    
    func configureCriticsViewController() {
        criticsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CriticsViewController") as? CriticsViewController
        addToParent(vc: criticsViewController!, to: containerView)
    }
    
    func setUpNavigation(text: String) {
        
        navigationItem.title = text
        if text == "Reviewes" {
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.663400948, blue: 0.4954517484, alpha: 1)
            navigationController?.navigationBar.isTranslucent = false
        } else {
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4809939901, green: 0.8862745098, blue: 0.9803921569, alpha: 1)
            navigationController?.navigationBar.isTranslucent = false
        }
        
    }

    
    @IBAction func onSegmentChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            if let vc = criticsViewController {
                deleteVC(vc: vc)
            }
            
            configureReviewesViewController()
            setUpNavigation(text: "Reviewes")
            setUpSCStyle(sender: sender, color: #colorLiteral(red: 1, green: 0.663400948, blue: 0.4954517484, alpha: 1))
        } else if sender.selectedSegmentIndex == 1 {
            
            if let vc = reviewesViewController {
                deleteVC(vc: vc)
            }
            configureCriticsViewController()
            setUpNavigation(text: "Critics")
            setUpSCStyle(sender: sender, color: #colorLiteral(red: 0.4809939901, green: 0.8862745098, blue: 0.9803921569, alpha: 1))
        }
    }
    
    func setUpSCStyle(sender: UISegmentedControl, color: UIColor) {
        backgroungSCView.backgroundColor = color
        sender.backgroundColor = color
        sender.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        sender.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
        if #available(iOS 13.0, *) {
            sender.selectedSegmentTintColor = color
        } else {
            if color == #colorLiteral(red: 1, green: 0.663400948, blue: 0.4954517484, alpha: 1) {
                sender.backgroundColor = #colorLiteral(red: 0.933313787, green: 0.6353278756, blue: 0.4940687418, alpha: 1)
                sender.tintColor = color
                sender.layer.borderWidth = 1
                sender.layer.borderColor = #colorLiteral(red: 0.933313787, green: 0.6353278756, blue: 0.4940687418, alpha: 1).cgColor
                sender.layer.cornerRadius = 5
            } else {
                sender.backgroundColor = #colorLiteral(red: 0.4782466292, green: 0.8353435397, blue: 0.9214532971, alpha: 1)
                sender.tintColor = color
                sender.layer.borderWidth = 1
                sender.layer.borderColor = #colorLiteral(red: 0.4782466292, green: 0.8353435397, blue: 0.9214532971, alpha: 1).cgColor
                sender.layer.cornerRadius = 5
            }
        }
    }
    
}
