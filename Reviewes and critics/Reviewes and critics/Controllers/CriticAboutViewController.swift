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
    
    @IBOutlet weak var criticImageView: UIImageView!
    @IBOutlet weak var criticNameLabel: UILabel!
    @IBOutlet weak var criticStatusButton: UIButton!
    @IBOutlet weak var criticBioLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var bioTxt: String? = ""
    var offset = 0
    var hasMore = true
    var reviews: [Review] = []
    var reviewer: String?
    let sessionForCritics = SessionForCritics()
    let sessionForReviewes = SessionForCriticReviwes()
    
    private let reviewCellIdentifier = String(describing: ReviewesCollectionViewCell.self)
    
    private let sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
       let lineSpacing: CGFloat = 20
       let itemSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupCollectionViewLayout()
        setupUI()
        loadCriticInfo()
        loadReviewes()
        
    }
    
    private func loadCriticInfo() {
        sessionForCritics.loadCritics(reviewer: reviewer ?? "") { [weak self] success, error in
            DispatchQueue.main.async {
                
                //Critic name label
                self?.criticNameLabel.text = success?.critics.compactMap { $0.criticName }.joined()
                
                //Critic bio label
                self?.bioTxt = success?.critics.compactMap { $0.bio }.joined()
                self?.criticBioLabel.text = self?.bioTxt
//                self?.criticBioLabel.text = self?.bioTxt?.strippingHTML()
                
                //Critic status
                self?.criticStatusButton.setTitle(success?.critics.compactMap { $0.status }.joined(), for: .normal)
                self?.criticStatusButton.addTarget(self, action: #selector(self?.buttonAction), for: .touchUpInside)
                self?.criticStatusButton.layer.borderWidth = 1.0
                self?.criticStatusButton.layer.masksToBounds = true
                self?.criticStatusButton.layer.borderColor = #colorLiteral(red: 0.7096869946, green: 0.8863267303, blue: 0.9802721143, alpha: 1)
                self?.criticStatusButton.layer.backgroundColor = #colorLiteral(red: 0.7096869946, green: 0.8863267303, blue: 0.9802721143, alpha: 1)
//                let size = self?.criticStatusButton.frame.height
                self?.criticStatusButton.layer.cornerRadius = 10.0
                
                //Critic image
                let urlTemplate = success?.critics.compactMap { $0.cover }.compactMap { $0.resource }.compactMap { $0.src }.joined() ?? ""
                self?.criticImageView.kf.setImage(with: URL(string: urlTemplate), placeholder: UIImage(named: "defaultImage"))
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        criticBioLabel.isHidden.toggle()
    }
    
    @objc private func searchReviewesPlusFetch() {
            
        offset = 0
        reviews = []
        loadReviewes()
    }
    
    private func loadReviewes() {
        
        sessionForReviewes.loadReviewes(offset: offset, reviewer: reviewer) { [weak self] success, error in
            guard let self = self, let success = success else {

                print(String(describing: error))
                return
            }

            self.reviews += success.reviews
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
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellIdentifier, for: indexPath) as? ReviewesCollectionViewCell else { fatalError() }
        let review = self.reviews[indexPath.row]
        cell.configure(with: review)
        return cell
    }
    
    func collectionView(_ collectionView:UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == reviews.count - 1 && hasMore {
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

extension String {
    /// Using regular expressions is not a correct approach for converting HTML to text, there are many pitfalls, like handling <style> and <script> tags. On platforms that support Foundation, one alternative is to use NSAttributedString's basic HTML support. Care must be taken to handle extraneous newlines and object replacement characters left over from the conversion process. It is a good idea to cache complex generated NSAttributedStrings either through storage or NSCache.
    func strippingHTML() throws -> String?  {
        if isEmpty {
            return nil
        }
        if let data = data(using: .utf8) {
            let attributedString = try NSAttributedString(data: data,
                                                          options: [.documentType : NSAttributedString.DocumentType.html,
                                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil)
            var string = attributedString.string
            // These steps are optional, and it depends on how you want handle whitespace and newlines
            string = string.replacingOccurrences(of: "\u{FFFC}",
                                                 with: "",
                                                 options: .regularExpression,
                                                 range: nil)
            string = string.replacingOccurrences(of: "(\n){3,}",
                                                 with: "\n\n",
                                                 options: .regularExpression,
                                                 range: nil)
            return string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return nil
    }
}
