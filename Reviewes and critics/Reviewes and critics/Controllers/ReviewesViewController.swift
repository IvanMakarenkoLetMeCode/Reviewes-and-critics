//
//  ReviewesViewController.swift
//  Reviewes and critics
//
//  Created by Ivan on 24.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    
    let datePicker = UIDatePicker()
    let sessionForReviewes = SessionForReviewes()
    var reviews: [ReviewesCellItem] = []
    var hasMore = true
    var nextPageLoading = false
    
    var typeRequest = "all"
    var openingDate = ""
    var offset = 0
    var order = ""
    var query = ""
    private let reviewCellIdentifier = String(describing: ReviewesCollectionViewCell.self)
    private let refreshControlCellIdentifier = String(describing: RefreshCollectionReusableView.self)
    
    private let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let lineSpacing: CGFloat = 20
    let itemSpacing: CGFloat = 10
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Reload items...")
        refreshControl.addTarget(self, action: #selector(searchReviewesPlusFetch), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        setupCollectionViewLayout()
        collectionView.refreshControl = myRefreshControl
        setupUI()
        createSearchBar()
        createDatePicker()
        loadReviewes()
        
    }
    
    //    func setUpRefresh() {
    //        collectionView.addSubview(myRefreshControl)
    //        self.collectionView.collectionFooter
    //    }
    
    @objc private func searchReviewesPlusFetch() {
        
        offset = 0
        reviews = []
        loadReviewes()
    }
    
    private func loadReviewes() {
        
        sessionForReviewes.loadReviewes(typeRequest: typeRequest,openingDate: openingDate, offset: offset, order: order, query: query) { [weak self] success, error in
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
                    //                    dataMovie.insert(" ", at: dataMovie.index(dataMovie.startIndex, offsetBy: 10))
                    //                    dataMovie.insert(" ", at: dataMovie.index(dataMovie.startIndex, offsetBy: 10))
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
            self.reviews += items
            self.hasMore = success.hasMore
            DispatchQueue.main.async {
                self.nextPageLoading = false
                self.myRefreshControl.endRefreshing()
                self.collectionView.reloadData()
            }
        }
        
    }
    
    private func setupUI() {
        
        collectionView.register(UINib(nibName: reviewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: reviewCellIdentifier)
        collectionView.register(UINib(nibName: refreshControlCellIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: refreshControlCellIdentifier)
    }
    
    //    private func setupCollectionViewLayout() {
    //        let layout = UICollectionViewFlowLayout()
    //        let width = view.bounds.size.width - itemSpacing - sectionInset.left
    //        layout.estimatedItemSize = CGSize(width: width, height: 10)
    //        self.collectionView.collectionViewLayout = layout
    //    }
    
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
        
        //toolbar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        //        toolbar.sizeToFit()
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
        
        guard let text = titleTxt.text, !text.isEmpty else { return }
        query = text
        typeRequest = "search"
        order = "by-title"
        openingDate = ""
        searchReviewesPlusFetch()
        self.view.endEditing(true)
    }
    
    func createDatePicker() {
        //image
        let imageView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: 24.0, height: 24.0))
        let image = UIImage(named: "dateImage")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        //        imageView.backgroundColor = .red
        //        imageView.tintColor = .white
        //        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.layoutMargins = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 40))
        emptyView.addSubview(imageView)
        //        emptyView.backgroundColor = .green
        dateTxt.leftViewMode = .always
        dateTxt.leftView = emptyView
        
        //style
        dateTxt.textAlignment = .center
        dateTxt.placeholder = "2020/01/01"
        
        //toolbar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        //        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor(named: "ColorGrayLaD")
        
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneBtn, spaceButton, cancelBtn], animated: true)
        
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
        typeRequest = "search"
        order = "by-opening-date"
        query = ""
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
        let cellItem = reviews[indexPath.row]
        cell.configure(with: cellItem)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView:UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == reviews.count - 1 && hasMore && !nextPageLoading {
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - itemSpacing - sectionInset.left , height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - itemSpacing - sectionInset.left, height: 50)
    }
}

extension Date {
    func getFormattedDate(format: String, datePicker: UIDatePicker) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: datePicker.date)
    }
}

extension ReviewesViewController: ReviewesCollectionViewCellDelegate {
    func shareButtonTouchUpIns(_ cell: ReviewesCollectionViewCell) {
        guard let index = collectionView.indexPath(for: cell)?.row else { return }
        var text = "Hey! Check out this article on The New York Times:\r"
        text += reviews[index].linkUrl ?? ""
        guard let urlTemplate = reviews[index].imageUrl else { return }
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
}
