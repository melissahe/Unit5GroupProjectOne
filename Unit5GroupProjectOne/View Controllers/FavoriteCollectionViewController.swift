//
//  FavoriteCollectionViewController.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/18/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

//Message by Melissa: This will be the view controller that displays the collection view (the second tab)

class FavoriteCollectionViewController: UIViewController {
    
    private let cellSpacing: CGFloat = UIScreen.main.bounds.width * 0.025
    private let favoriteView = VenueCollectionView()
    private var selectedCellIndex = 0
    
    //set up the did select delegate method so that clicking one collection view cell should segue to a detail view that lists all the venues
    private var collectionNames = FileManagerHelper.manager.getCollectionNames()
    private var collections = FileManagerHelper.manager.getCollections() {
        didSet {
            favoriteView.venueCollectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteView.venueCollectionView.dataSource = self
        favoriteView.venueCollectionView.delegate = self
        constraints()
        navigationItem.title = "My Collection"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createCollection))
        navigationController?.navigationBar.tintColor = UIColor(red: 0.67, green: 0.07, blue: 0.50, alpha: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionNames = FileManagerHelper.manager.getCollectionNames()
        collections = FileManagerHelper.manager.getCollections()
    }
    @objc private func createCollection() {
        let modalVC = CreateFavoriteViewController()
        let navController = UINavigationController(rootViewController: modalVC)
        modalVC.view.backgroundColor = .white
        self.present(navController, animated: true, completion: nil)
    }
    private func constraints() {
        view.addSubview(favoriteView)
        let safe = view.safeAreaLayoutGuide
        favoriteView.snp.makeConstraints { (view) in
            view.top.bottom.leading.trailing.equalTo(safe)
        }
    }
}
extension FavoriteCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.selectedCellIndex = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VenueCollectionCell", for: indexPath) as! VenueCollectionViewCell
        let currentCollection = collections[indexPath.row]
        let currentCollectionTitle = collectionNames[indexPath.row]
        cell.configureCell(withCollection: currentCollection, andTitle: currentCollectionTitle, adding: false)
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(_:)))
        cell.addGestureRecognizer(holdGesture)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentCollection = collections[indexPath.row]
        let currentCollectionTitle = collectionNames[indexPath.row]
        
        let collectionList = VenueListViewController(navTitle: currentCollectionTitle, savedVenues: currentCollection)
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
            cell!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) }, completion: { finished in
                UIView.animate(withDuration: 0.06, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseIn, animations: { cell!.transform = CGAffineTransform(scaleX: 1, y: 1) }, completion: { (_) in
                    self.navigationController?.pushViewController(collectionList, animated: true)
                } )})
    }
    
    @objc private func cellLongPressed(_ sender: VenueCollectionViewCell) {
        holdAlert(index: selectedCellIndex)
    }
    private func holdAlert(index: Int) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            print("Deleted")

            FileManagerHelper.manager.removeCollection(atIndex: index)
            
            self.collections = FileManagerHelper.manager.getCollections()
            self.collectionNames = FileManagerHelper.manager.getCollectionNames()
            
            self.favoriteView.venueCollectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_) in
            print("Edited")
            self.editAlert()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func editAlert() {
        let alert = UIAlertController(title: "Edit name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new name"
            let currentName = self.collectionNames[self.selectedCellIndex]
            textField.text = currentName
        }
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            let oldName = self.collectionNames[self.selectedCellIndex]
            let currentIndex = self.selectedCellIndex
            
            guard let editedName = alert.textFields![0].text, !editedName.isEmpty else {
                let alertController = UIAlertController(title: "Error", message: "You must give the collection a name.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            FileManagerHelper.manager.updateCollectionName(atIndex: currentIndex, withName: editedName)
            
            self.collectionNames = FileManagerHelper.manager.getCollectionNames()
            self.collections = FileManagerHelper.manager.getCollections()
            self.favoriteView.venueCollectionView.reloadData()
            
            let alertController = UIAlertController(title: "Success", message: "\"\(oldName)\" was changed to \"\(editedName)\"", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension FavoriteCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 2
        let numberOfSpaces: CGFloat = numberOfCells + 1
        let width = (collectionView.bounds.width - (numberOfSpaces * cellSpacing)) / numberOfCells
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }
}
