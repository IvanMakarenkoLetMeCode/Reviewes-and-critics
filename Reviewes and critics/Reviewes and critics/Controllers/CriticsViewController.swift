//
//  CriticsViewController.swift
//  Reviewes and critics
//
//  Created by Ivan on 24.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class CriticsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleTxt: UITextField!
    
    let sessionForCritics = SessionForCritics()
    var critics: [Critic] = []
    var reviewer: String? = "all"
    
    private let criticCellIdentifier = String(describing: CriticsCollectionViewCell.self)
    
    private let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       let lineSpacing: CGFloat = 10
       let itemSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewLayout()
        setupUI()
        createSearchBar()
        loadCritics()
    }
    
    @objc private func searchCriticsPlusFetch() {
            
        critics = []
        loadCritics()
    }
    
    private func loadCritics() {
        
        sessionForCritics.loadCritics(reviewer: reviewer ?? "all") { [weak self] success, error in
            guard let self = self, let success = success else {

                print(String(describing: error))
                return
            }

            self.critics += success.critics
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
            }
        }
        
    }
    
    func createSearchBar() {
            //image
            let imageView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: 24.0, height: 24.0))
            let image = UIImage(named: "searchImage")
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
    //        imageView.backgroundColor = .red
    //        imageView.tintColor = .white
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        imageView.layoutMargins = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
            let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 40))
            emptyView.addSubview(imageView)
    //        emptyView.backgroundColor = .green
            titleTxt.leftViewMode = .always
            titleTxt.leftView = emptyView
            
            //style
            titleTxt.textAlignment = .center
            titleTxt.placeholder = "Enter full Name"
            
            //toolbar
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            toolbar.backgroundColor = UIColor.yellow
            
            let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: #selector(searchPressed))
            let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelClicked))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([searchBtn] + [spaceButton] + [cancelBtn], animated: true)
            
            //assign toolbar
            titleTxt.inputAccessoryView = toolbar
        }
    
    @objc func cancelClicked(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @objc func searchPressed() {
        
        guard let text = titleTxt.text, !text.isEmpty else { return }
        reviewer = text.replacingOccurrences(of: " ", with: "%20")
        if reviewer == "" {
            reviewer = "all"
        }
        searchCriticsPlusFetch()
        self.view.endEditing(true)
    }
    
    private func setupUI() {
        
        collectionView.register(UINib(nibName: criticCellIdentifier, bundle: nil), forCellWithReuseIdentifier: criticCellIdentifier)
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.size.width / 2 - itemSpacing / 2 - sectionInset.left
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        self.collectionView.collectionViewLayout = layout
    }
    
}

// MARK: - UICollectionViewDataSource

extension CriticsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return critics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: criticCellIdentifier, for: indexPath) as? CriticsCollectionViewCell else { fatalError() }
        let critic = critics[indexPath.row]
        cell.configure(with: critic)
        return cell
    }
    
//    func collectionView(_ collectionView:UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let lastRow = indexPath.row
//        if lastRow == critics.count - 1 && hasMore {
//            fetchNextPage()
//        }
//    }
//
//    private func fetchNextPage() {
//        offset += 20
//        loadReviewes()
//    }
}

extension CriticsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}
