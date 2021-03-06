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
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    var offset = 0
    var hasMore = true
    var dataSource: [VCellPresenting] = []
    var reviewer: String?
    let sessionForCritics = SessionForCritics()
    let sessionForReviewes = SessionForCriticReviwes()
    var nextPageLoading = false
    
    
    
    private let reviewCellIdentifier = String(describing: ReviewesCollectionViewCell.self)
    private let criticInfoCellIdentifier = String(describing: CriticInfoCollectionViewCell.self)
    private let refreshControlCellIdentifier = String(describing: RefreshCollectionReusableView.self)
    
    private let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let lineSpacing: CGFloat = 10
    let itemSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewLayout()
        setupUI()
        loadCriticInfo()
        
        loadReviewes()
        setUpNavigation(text: reviewer ?? "")
        
    }
    
    func setUpNavigation(text: String) {
        
        navigationItem.title = text
        navigationController?.navigationBar.barTintColor = UIColor(named: "ColorNavigationCritics")
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func loadCriticInfo() {
        sessionForCritics.loadCritics(reviewer: reviewer ?? "") { [weak self] success, error in
            
            guard let critics = success?.critics else { return }
            DispatchQueue.main.async {
                let items = critics.map({ critic -> CriticInfoICellItem in
                    var imageCritic: URL?
                    var bioAtrStr: NSAttributedString?
                    if let urlString = critic.cover?.resource?.src {
                        imageCritic = URL(string: urlString)
                    }
                    if let bioString = critic.bio {
                        bioAtrStr = bioString.convertHTMLStringToAttributed(fontName: "System", fontSize: 13)
                    }
                    return CriticInfoICellItem(criticName: critic.criticName, imageCritic: imageCritic, status: critic.status, bio: bioAtrStr)
                    
                })
                if let critic = items.first {
                    
                    self?.dataSource.insert(critic, at: 0)
                }
                self?.collectionView.reloadData()
            }
        }
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
                var dataMovie: String
                if let urlString = review.cover?.src {
                    imageUrl = URL(string: urlString)
                }
                if review.createData != nil {
                    dataMovie = review.createData ?? ""
//                    dataMovie.removeSubrange(dataMovie.index(dataMovie.startIndex, offsetBy: 10)..<dataMovie.endIndex)
                    dataMovie.remove(at: dataMovie.index(dataMovie.startIndex, offsetBy: 4))
                    dataMovie.insert("/", at: dataMovie.index(dataMovie.startIndex, offsetBy: 4))
                    dataMovie.remove(at: dataMovie.index(dataMovie.startIndex, offsetBy: 7))
                    dataMovie.insert("/", at: dataMovie.index(dataMovie.startIndex, offsetBy: 7))
                    dataMovie.insert(" ", at: dataMovie.index(dataMovie.startIndex, offsetBy: 10))
//                    timeMovie.removeSubrange(timeMovie.startIndex..<timeMovie.index(dataMovie.startIndex, offsetBy: 10))
                } else {
                    dataMovie = "No dates"
                }
                
                return ReviewesCellItem(imageUrl: imageUrl,
                                        movieName: review.movieName,
                                        filmAbout: review.review,
                                        criticName: review.criticName,
                                        date: dataMovie,
                                        linkUrl: review.link?.url)
            })
            self.dataSource += items
            self.hasMore = success.hasMore
            DispatchQueue.main.async {
                self.nextPageLoading = false
                self.collectionView.reloadData()
            }
        }
        
    }
    
    private func setupUI() {
        
        collectionView.register(UINib(nibName: criticInfoCellIdentifier, bundle: nil), forCellWithReuseIdentifier: criticInfoCellIdentifier)
        collectionView.register(UINib(nibName: reviewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: reviewCellIdentifier)
        collectionView.register(UINib(nibName: refreshControlCellIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: refreshControlCellIdentifier)
        
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.size.width - itemSpacing - sectionInset.left - sectionInset.right
        layout.estimatedItemSize = CGSize(width: width, height: 100)
        self.collectionView.collectionViewLayout = layout
    }
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
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
            cell.delegate = self
            if let cellItem = item as? CriticInfoICellItem {
                cell.configure(with: cellItem)
            }
            return cell
        case .reviewes:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellIdentifier, for: indexPath) as? ReviewesCollectionViewCell else { fatalError() }
            cell.delegate = self
            if let cellItem = item as? ReviewesCellItem {
                cell.configure(with: cellItem)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView:UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == dataSource.count - 1 && hasMore && !nextPageLoading {
            fetchNextPage()
        }
    }
    
    private func fetchNextPage() {
        offset += 20
        nextPageLoading = true
        loadReviewes()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: refreshControlCellIdentifier, for: indexPath) as? RefreshCollectionReusableView else { fatalError() }
            footerView.set(animated: nextPageLoading)
            return footerView
        }
        fatalError()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - itemSpacing - sectionInset.left, height: 50)
    }

}

extension CriticAboutViewController: ReviewesCollectionViewCellDelegate {
    func shareButtonTouchUpIns(_ cell: ReviewesCollectionViewCell) {
        guard let index = collectionView.indexPath(for: cell)?.row else { return }
        var text = "Hey! Check out this article on The New York Times:\r"
        let item = dataSource[index]
        switch item.type {
        case .reviewes:
            if let cellItem = item as? ReviewesCellItem {
                text += cellItem.linkUrl ?? ""
                guard let urlTemplate = cellItem.imageUrl else { return }
                KingfisherManager.shared.retrieveImage(with: urlTemplate) { result in
                    var image = UIImage(named: "defaultImage") ?? UIImage()
                    switch result {
                    case let .success(imageResult):
                        image = imageResult.image
                    default:
                        break
                    }
                    let activityController = UIActivityViewController(activityItems: [image,
                                                                                      text], applicationActivities: nil)
                    self.present(activityController, animated: true)
                }
            }
        default:
            break
        }
    }
}

extension CriticAboutViewController: CriticInfoCollectionViewCellDelegate {
    func buttonActionTouchUpIns(_ cell: CriticInfoCollectionViewCell) {
        guard let index = collectionView.indexPath(for: cell) else { return }
        let item = dataSource[index.row]
        switch item.type {
        case .header:
            if var cellItem = item as? CriticInfoICellItem {
                cellItem.bioHidden.toggle()
                dataSource[index.row] = cellItem
            }
            
        default:
            break
        }
        collectionView.reloadData()
    }
}
