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
    var critics: [CriticCellItem] = []
    var reviewer: String? = "all"
    
    private let criticCellIdentifier = String(describing: CriticsCollectionViewCell.self)
    
    private let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       let lineSpacing: CGFloat = 10
       let itemSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupCollectionViewLayout()
        navigationItem.title = "Critics"
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
            
            let critics = success.critics
            let items = critics.map({ critic -> CriticCellItem in
                var imageUrl: URL?
                if let urlString = critic.cover?.resource?.src {
                    imageUrl = URL(string: urlString)
                }
                return CriticCellItem(criticName: critic.criticName, imageUrl: imageUrl)
            })
            
                self.critics += items
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

            let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 40))
            emptyView.addSubview(imageView)
    //        emptyView.backgroundColor = .green
            titleTxt.leftViewMode = .always
            titleTxt.leftView = emptyView
            
            //style
            titleTxt.textAlignment = .center
            titleTxt.placeholder = "Enter full Name"
            
            //toolbar
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
//            toolbar.sizeToFit()
            toolbar.backgroundColor = UIColor.lightGray
            
            let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: #selector(searchPressed))
            let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelClicked))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([searchBtn, spaceButton, cancelBtn], animated: true)
            
            //assign toolbar
            titleTxt.inputAccessoryView = toolbar
        }
    
    @objc func cancelClicked(sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @objc func searchPressed() {
        
        guard let text = titleTxt.text else { return }
        reviewer = text
        if reviewer == "" {
            reviewer = "all"
        }
        searchCriticsPlusFetch()
        self.view.endEditing(true)
    }
    
    private func setupUI() {
        
        collectionView.register(UINib(nibName: criticCellIdentifier, bundle: nil), forCellWithReuseIdentifier: criticCellIdentifier)
    }
    
//    private func setupCollectionViewLayout() {
//        let layout = UICollectionViewFlowLayout()
//        let width = view.bounds.size.width / 2 - itemSpacing / 2 - sectionInset.left - sectionInset.right
//        layout.estimatedItemSize = CGSize(width: width, height: 10)
//        self.collectionView.collectionViewLayout = layout
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let vc = segue.destination as? UINavigationController {
                if let criticVc = vc.topViewController as? CriticAboutViewController {
                    if let critic = sender as? CriticCellItem {
                        criticVc.reviewer = critic.criticName
                    }
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension CriticsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return critics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: criticCellIdentifier, for: indexPath) as? CriticsCollectionViewCell else { fatalError() }
        let cellItem = critics[indexPath.row]
        cell.configure(with: cellItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let critic = critics[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetail", sender: critic)
    }
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / 2 - itemSpacing / 2 - sectionInset.left - sectionInset.right , height: 205)
    }
}
