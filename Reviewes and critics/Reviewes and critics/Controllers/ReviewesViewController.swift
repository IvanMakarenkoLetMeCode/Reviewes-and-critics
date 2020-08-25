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
    var reviews: [Review] = []
    var hasMore = true
    
    var type = "all"
    var offset = 0
    var order = "by-title"
    private let reviewCellIdentifier = String(describing: ReviewesTableViewCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
        tableView.register(UINib(nibName: reviewCellIdentifier, bundle: nil), forCellReuseIdentifier: reviewCellIdentifier)
        reloadReviewes()
        
    }
    
    private func reloadReviewes() {
        
        sessionForReviewes.loadGames(type: type, offset: offset, order: order) { [weak self] success, error in
            guard let self = self, let success = success else {

                print(String(describing: error))
                return
            }

            self.reviews += success.reviews
            self.hasMore = success.hasMore
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == reviews.count - 1 && hasMore {
            fetchNextPage()
        }
    }
    
    private func fetchNextPage() {
        offset += 1
        reloadReviewes()
    }
    
}
