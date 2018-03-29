//
//  VenueDetailedViewController.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation

//Message by Melissa: This is the view controller that displays the detailed view

class VenueDetailedViewController: UIViewController {

    let detailView = VenueDetailedView()
    var venueDetail = [String]() {
        didSet {
            self.detailView.VenueDetailTableView.reloadData()
        }
    }
    
    var venue: Venue!
    var venueImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        constrainView()
        detailView.VenueDetailTableView.dataSource = self
        detailView.VenueDetailTableView.delegate = self
        navigationItem.title = venue.name
        //detailView.VenueDetailTableView.rowHeight = 50
    }
    
    @objc private func addButtonPressed() {
        if let venue = self.venue, let venueImage = self.venueImage {
            let addTipVC = AddCollectionTipViewController(venue: venue, VC: self, venueImage: venueImage)
            let navVC = UINavigationController(rootViewController: addTipVC)
            navigationController?.present(navVC, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Error", message: "This venue did not have any data. Please checking network connectivity, and search again.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //TODO: if time, for extra credit
    @objc private func editButtonPressed() {
        
    }
    
    private func constrainView() {
        view.addSubview(detailView)
        
        detailView.snp.makeConstraints { (view) in
            view.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}

extension VenueDetailedViewController {
    
    public func configureView(venue: Venue, tip: String?, saved: Bool) {
        
        if !saved {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        } else {
            //TODO: if time, for extra credit
//            navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        }
        
        self.venue = venue
        
        PhotoAPIClient.manager.getPhotos(venue: venue.id, completion: { (photo) in
            if let photo = photo.first {
                let photoURL = "\(photo.prefix)\(photo.width)x\(photo.height)\(photo.suffix)"
                var index = 0
                self.venueDetail.insert(photoURL, at: index)
                index += 1
                let category = self.venue.categories.map{$0.shortName}.joined(separator: ", ").replacingOccurrences(of: "/", with: "")
                if category.isEmpty {
                    self.venueDetail.insert("No Categories Available", at: index)
                } else {
                    self.venueDetail.insert(category, at: index)
                }
                index += 1
                if let tip = tip {
                    self.venueDetail.insert(tip, at: index)
                    index += 1
                }
                
                if let address = venue.location.formattedAddress {
                    self.venueDetail.insert(address.joined(separator: ", "), at: index)
                    index += 1
                } else {
                    self.venueDetail.insert("No Address Available", at: index)
                    index += 1
                }
            } else {
                let noPhotoText = "No URL Available"
                
                var index = 0
                self.venueDetail.insert(noPhotoText, at: index)
                index += 1
                let category = self.venue.categories.map{$0.shortName}.joined(separator: ", ").replacingOccurrences(of: "/", with: "")
                if category.isEmpty {
                    self.venueDetail.insert("No Categories Available", at: index)
                } else {
                    self.venueDetail.insert(category, at: index)
                }
                index += 1
                if let tip = tip {
                    self.venueDetail.insert(tip, at: index)
                    index += 1
                }
                
                if let address = venue.location.formattedAddress {
                    self.venueDetail.insert(address.joined(separator: ", "), at: index)
                    index += 1
                } else {
                    self.venueDetail.insert("No Address Available", at: index)
                    index += 1
                }
            }
        }, errorHandler: { (_) in
            let noPhotoText = "No URL Available"
            
            var index = 0
            self.venueDetail.insert(noPhotoText, at: index)
            index += 1
            let category = self.venue.categories.map{$0.shortName}.joined(separator: ", ").replacingOccurrences(of: "/", with: "")
            if category.isEmpty {
                self.venueDetail.insert("No Categories Available", at: index)
            } else {
                self.venueDetail.insert(category, at: index)
            }
            index += 1
            if let tip = tip {
                self.venueDetail.insert(tip, at: index)
                index += 1
            }

            if let address = venue.location.formattedAddress {
                self.venueDetail.insert(address.joined(separator: ", "), at: index)
                index += 1
            } else {
                self.venueDetail.insert("No Address Available", at: index)
                index += 1
            }
        })
    }
}

extension VenueDetailedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.layer.bounds.height * 0.70
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == venueDetail.count - 1 {
            var urlString: String!
            
            //can use user location
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                if let latitude = UserPreferences.manager.getUserCoordinate().latitude, let longitude = UserPreferences.manager.getUserCoordinate().longitude {
                    urlString = "http://maps.apple.com/maps?saddr=\(latitude),\(longitude)&daddr=\(venue.location.lat),\(venue.location.lng)"
                    print("got user location")
                }
            } else { //can't use user location
                if let latitude = UserPreferences.manager.getSearchCoordinates().latitude, let longitude = UserPreferences.manager.getSearchCoordinates().longitude {
                    print("got search location")
                    urlString = "http://maps.apple.com/maps?saddr=\(latitude),\(longitude)&daddr=\(venue.location.lat),\(venue.location.lng)"
                }
            }
            
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else { //only present the location, not directions
                let singleLocation = "http://maps.apple.com/maps?saddr=\(venue.location.lat),\(venue.location.lng)"
                UIApplication.shared.open(URL(string: singleLocation)!, options: [:], completionHandler: nil)
                print("got single location")
            }
        }
    }
}

extension VenueDetailedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
        let venue = venueDetail[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? VenueDetailedTableViewCell {
            if indexPath.row == 0 {
                if let urlImage = URL(string: venue) {
                    cell.venueImage.image = nil
                    cell.venueImage.kf.indicatorType = .activity
                    ImageCache.default.retrieveImage(forKey: self.venue.id, options: nil){(image, cache) in
                        if let image = image {
                            cell.venueImage.image = image
                            self.venueImage = image
                        } else {
                            cell.venueImage.kf.setImage(with: urlImage, placeholder: UIImage.init(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: { (image, error, cache, url) in
                                cell.layoutIfNeeded()
                                cell.detailDescriptionLabel.text = nil
                                if let image = image {
                                    cell.venueImage.image = image
                                    self.venueImage = image
                                    ImageCache.default.store(image, forKey: self.venue.id)
                                }
                            })
                        }
                    }
                } else {
                    cell.venueImage.image = #imageLiteral(resourceName: "placeholder")
                    self.venueImage = #imageLiteral(resourceName: "placeholder")
                }
            } else {
                cell.detailDescriptionLabel.text = venue
            }
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            return cell
        }
        return UITableViewCell()
    }
    
    
}
