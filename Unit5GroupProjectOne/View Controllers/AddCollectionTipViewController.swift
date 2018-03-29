//
//  AddCollectionTipViewController.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class AddCollectionTipViewController: UIViewController {
    
    let cellSpacing: CGFloat = UIScreen.main.bounds.width * 0.025
    
    let addTipView = AddCollectionTipView()
    var venue: Venue!
    var previousVC: VenueDetailedViewController!
    var venueImage: UIImage!
    var savedCollectionNames = FileManagerHelper.manager.getCollectionNames()
    var savedCollections = FileManagerHelper.manager.getCollections()
    
    init(venue: Venue, VC: VenueDetailedViewController, venueImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.venue = venue
        self.previousVC = VC
        self.venueImage = venueImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constrainView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCollection))
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 0.67, green: 0.07, blue: 0.50, alpha: 1)
        navigationController?.navigationBar.backgroundColor = .orange
        backHomeButton()
        self.addTipView.venueTipCollectionView.delegate = self
        self.addTipView.venueTipCollectionView.dataSource = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.addTipView.resignFirstResponder()
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveCollection() {
        guard let collectionName = addTipView.venueTipTextField.text else {
            let emptyCollectionNameAlert = createAlertController(withTitle: "Error", andMessage: "You cannot create a collection without a name.")
            self.present(emptyCollectionNameAlert, animated: true, completion: nil)
            return
        }
        var tip: String!
        if let tipText = addTipView.venueTipTextView.text {
            tip = tipText
        }
        //TODO: get the image from dependency injection!!! from the detailed view controller
        guard let data = UIImagePNGRepresentation(venueImage) else {
            let imageAlert = createAlertController(withTitle: "Error", andMessage: "Could not convert image to data.")
            self.present(imageAlert, animated: true, completion: nil)
            return
        }
        let newVenueTipModel = VenueTipModel(venue: venue, tip: tip, imageData: data)
        
        let saveSuccessful = FileManagerHelper.manager.addNewCollection([newVenueTipModel], withCollectionName: collectionName)
        
        if saveSuccessful {
            let successAlert = UIAlertController(title: "Success", message: "\"\(venue.name)\" was saved to your collection \"\(collectionName)\".", preferredStyle: .alert)
            let actionAlert = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
                self.addTipView.resignFirstResponder()
            })
            successAlert.addAction(actionAlert)
            self.present(successAlert, animated: true, completion: nil)
        } else {
            let errorAlert = createAlertController(withTitle: "Error", andMessage: "\"\(collectionName)\" already exists as a collection name.")
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    private func backHomeButton() {
        addTipView.homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
    }
    
    @objc private func homeButtonPressed() {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: [], animations: {
            
            self.addTipView.homeButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) }, completion: { finished in
                UIView.animate(withDuration: 0.06, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseIn, animations: { self.addTipView.homeButton.transform = CGAffineTransform(scaleX: 1, y: 1) }, completion: { (_) in
                    self.dismissView()
                    self.navigationController?.pushViewController(SearchViewController(), animated: true)
                    self.previousVC.navigationController?.dismiss(animated: true, completion: nil)
                } )})
        
    }
    
    private func constrainView() {
        view.addSubview(addTipView)
        
        addTipView.snp.makeConstraints { (view) in
            view.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func createAlertController(withTitle title: String?, andMessage message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        return alertController
    }
}

extension AddCollectionTipViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //should also save and add to existing collection
        var tip: String!
        if let tipText = self.addTipView.venueTipTextView.text {
            tip = tipText
        }
        guard let data = UIImagePNGRepresentation(venueImage) else {
            let imageAlert = createAlertController(withTitle: "Error", andMessage: "Could not convert image to data.")
            self.present(imageAlert, animated: true, completion: nil)
            return
        }
        let newSavedVenue = VenueTipModel(venue: venue, tip: tip, imageData: data)
        let saveSuccessful = FileManagerHelper.manager.addVenueToExistingCollection(venue: newSavedVenue, withCollectionIndex: indexPath.row)
        
        let collectionName = savedCollectionNames[indexPath.row]
        
        if saveSuccessful {
            let successAlert = UIAlertController(title: "Success", message: "\"\(venue.name)\" was saved to your collection \"\(collectionName)\".", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
                self.addTipView.resignFirstResponder()
            })
            successAlert.addAction(alertAction)
            self.present(successAlert, animated: true, completion: nil)
        } else {
            let errorAlert = createAlertController(withTitle: "Error", andMessage: "\"\(collectionName)\" already has the venue \"\(venue.name)\".")
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
}

extension AddCollectionTipViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedCollections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCollectionTipCell", for: indexPath) as! VenueCollectionViewCell
        let currentTitle = savedCollectionNames[indexPath.row]
        let currentCollection = savedCollections[indexPath.row]
        
        cell.configureCell(withCollection: currentCollection, andTitle: currentTitle, adding: true)
        cell.layoutIfNeeded()
        
        return cell
    }
    
    
}

extension AddCollectionTipViewController: UICollectionViewDelegateFlowLayout {
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
