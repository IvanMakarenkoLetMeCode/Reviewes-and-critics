//
//  ReviewesViewController.swift
//  Reviewes and critics
//
//  Created by Ivan on 24.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

class ReviewesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    
    let datePicker = UIDatePicker()
    let sessionForReviewes = SessionForReviewes()
    var reviews: [Review] = []
    var hasMore = true
    
    var openingDate = "1900-01-01"
    var offset = 0
    var order = "by-opening-date"
    var query = ""
    private let reviewCellIdentifier = String(describing: ReviewesCollectionViewCell.self)
    
    private let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       let lineSpacing: CGFloat = 20
       let itemSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewLayout()
        setupUI()
        createSearchBar()
        createDatePicker()
        loadReviewes()
        
    }
    
    @objc private func searchReviewesPlusFetch() {
            
        offset = 0
        reviews = []
        loadReviewes()
    }
    
    private func loadReviewes() {
        
        sessionForReviewes.loadGames(openingDate: openingDate, offset: offset, order: order, query: query) { [weak self] success, error in
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
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.size.width / 2 - itemSpacing / 2 - sectionInset.left
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        self.collectionView.collectionViewLayout = layout
    }
    
    func createSearchBar() {
        titleTxt.textAlignment = .center
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: #selector(searchPressed))
        toolbar.setItems([searchBtn], animated: true)
        
//        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(CancelClicked))
//        toolbar.setItems([cancelBtn], animated: true)
        
        //assign toolbar
        titleTxt.inputAccessoryView = toolbar
    }
    
//    @objc func CancelClicked(sender: UIBarButtonItem) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @objc func searchPressed() {
        
        guard let text = titleTxt.text, !text.isEmpty else { return }
        query = text
        self.view.endEditing(true)
        searchReviewesPlusFetch()
    }
    
    func createDatePicker() {
        
        dateTxt.textAlignment = .center
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        dateTxt.inputAccessoryView = toolbar
        
        //assign date picker to the text field
        dateTxt.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        //formatter
        let date = Date()
        let formate = date.getFormattedDate(format: "yyyy/MM/dd", datePicker: datePicker)
        openingDate = date.getFormattedDate(format: "yyyy-MM-dd", datePicker: datePicker)
        
        dateTxt.text = formate
        self.view.endEditing(true)
        searchReviewesPlusFetch()
    }
    
}

// MARK: - UICollectionViewDataSource

extension ReviewesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellIdentifier, for: indexPath) as? ReviewesCollectionViewCell else { fatalError() }
        let review = reviews[indexPath.row]
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

extension ReviewesViewController: UICollectionViewDelegateFlowLayout {
    
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

extension Date {
    func getFormattedDate(format: String, datePicker: UIDatePicker) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: datePicker.date)
    }
}
