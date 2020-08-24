//
//  ReviewesViewController.swift
//  Reviewes and critics
//
//  Created by Ivan on 24.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class ReviewesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let sessionForReviewes = SessionForReviewes()
    var reviews: [Results] = []
    
    private let reviewCellIdentifier = String(describing: ReviewesTableViewCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
        tableView.register(UINib(nibName: reviewCellIdentifier, bundle: nil), forCellReuseIdentifier: reviewCellIdentifier)
        reloadReviewes()
        
    }
    
    private func reloadReviewes() {
        
        sessionForReviewes.loadGames { [weak self] reviews, error in
            guard let self = self, let reviews = reviews else {
                
                print(String(describing: error))
                return
            }
            
            self.reviews += reviews
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
        
    }
    
}

// MARK: - UITableViewDataSource
extension ReviewesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellIdentifier, for: indexPath) as? ReviewesTableViewCell else { fatalError() }
        let review = reviews[indexPath.row]
        cell.configure(with: review)
        return cell
    }
    
}
