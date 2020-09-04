//
//  CriticAboutViewController.swift
//  Reviewes and critics
//
//  Created by Ivan on 24.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit
import Kingfisher

class CriticAboutViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var offset = 0
    var hasMore = true
    var dataSource: [VCellPresenting] = []
    var reviewer: String?
    let sessionForCritics = SessionForCritics()
    let sessionForReviewes = SessionForCriticReviwes()
    
    
    
    private let reviewCellIdentifier = String(describing: ReviewesCollectionViewCell.self)
    private let criticInfoCellIdentifier = String(describing: CriticInfoCollectionViewCell.self)
    
    private let sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
       let lineSpacing: CGFloat = 20
       let itemSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupCollectionViewLayout()
        setupUI()
//        loadCriticInfo()
        loadReviewes()
        setUpNavigation(text: reviewer ?? "")
        
    }
    
    func setUpNavigation(text: String) {
        
        navigationItem.title = text
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.4809939901, green: 0.8862745098, blue: 0.9803921569, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func loadCriticInfo() {
        sessionForCritics.loadCritics(reviewer: reviewer ?? "") { [weak self] success, error in
            
            guard let critics = success?.critics else { return }
            let items = critics.map({ critic -> CriticInfoICellItem in
                var imageCritic: URL?
                if let urlString = critic.cover?.resource?.src {
                    imageCritic = URL(string: urlString)
                }
                return CriticInfoICellItem(criticName: critic.criticName, imageCritic: imageCritic, status: critic.status, bio: critic.bio)
            })
            self?.dataSource += items
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc private func searchReviewesPlusFetch() {
            
        offset = 0
        dataSource = []
        loadReviewes()
    }
    
    private func loadReviewes() {
        
        sessionForReviewes.loadReviewes(offset: offset, reviewer: reviewer) { [weak self] success, error in
            guard let self = self, let success = success else {

                print(String(describing: error))
                return
            }

            let reviews = success.reviews
            let items = reviews.map({ review -> ReviewesCellItem in
                var imageUrl: URL?
                if let urlString = review.cover?.src {
                    imageUrl = URL(string: urlString)
                }
                return ReviewesCellItem(imageUrl: imageUrl,
                                        movieName: review.movieName,
                                        filmAbout: review.review,
                                        criticName: review.criticName,
                                        dataReview: review.createData)
            })
            self.dataSource += items
            self.hasMore = success.hasMore
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
            }
        }
        
    }
    
    private func setupUI() {
        
        collectionView.register(UINib(nibName: reviewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: reviewCellIdentifier)
    }
    
//    private func setupCollectionViewLayout() {
//        let layout = UICollectionViewFlowLayout()
//        let width = view.bounds.size.width - itemSpacing - sectionInset.left
//        layout.estimatedItemSize = CGSize(width: width, height: 10)
//        self.collectionView.collectionViewLayout = layout
//    }
    
}

// MARK: - UICollectionViewDataSource
extension CriticAboutViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource[indexPath.row]
        switch item.type {
        case .header:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: criticInfoCellIdentifier, for: indexPath) as? CriticInfoCollectionViewCell else { fatalError() }
            if let cellItem = item as? CriticInfoICellItem {
                cell.configure(with: cellItem)
            }
            return cell
        case .reviewes:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellIdentifier, for: indexPath) as? ReviewesCollectionViewCell else { fatalError() }
            if let cellItem = item as? ReviewesCellItem {
                cell.configure(with: cellItem)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView:UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == dataSource.count - 1 && hasMore {
            fetchNextPage()
        }
    }
    
    private func fetchNextPage() {
        offset += 20
        loadReviewes()
    }
}

extension CriticAboutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - itemSpacing - sectionInset.left , height: 230)
    }
}

