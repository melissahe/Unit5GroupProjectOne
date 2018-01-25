//
//  VenueDetailedViewController.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

//Message by Melissa: This is the view controller that displays the detailed view

class VenueDetailedViewController: UIViewController {

    let detailView = VenueDetailedView()
    var venueDetail = [String]() {
        didSet {
            self.detailView.VenueDetailTableView.reloadData()
        }
    }
    
    var venue: Venue!

    override func viewDidLoad() {
        super.viewDidLoad()
        constrainView()
        detailView.VenueDetailTableView.dataSource = self
        detailView.VenueDetailTableView.delegate = self
        detailView.VenueDetailTableView.rowHeight = 50
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(AddButtonPressed))
    }
    
    @objc private func AddButtonPressed() {
        let addTipVC = AddCollectionTipViewController(venue: self.venue, VC: self)
        
        let navVC = UINavigationController(rootViewController: addTipVC)
        
        navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    private func constrainView() {
        view.addSubview(detailView)
        
        detailView.snp.makeConstraints { (view) in
            view.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}

extension VenueDetailedViewController {
    public func configureView(venue: Venue, tip: String?) {
        self.venue = venue
        
        PhotoAPIClient.manager.getPhotos(venue: venue.id) { (photo) in
            if let photo = photo?.first {
                let photoURL = "\(photo.prefix)\(photo.width)x\(photo.height)\(photo.suffix)"
                self.venueDetail[0] = photoURL
            }
        }
        let category = venue.categories[0].name
        //print(category)
        venueDetail.append(category)
        if let tip = tip {
            venueDetail.append(tip)
        }
        if let address = venue.location.address {
            venueDetail.append(address)
        }
        
    }
}

extension VenueDetailedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: open maps
    }
}

extension VenueDetailedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: add array count
        return venueDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? VenueDetailedTableViewCell {
            if indexPath.row < venueDetail.count {
                let venue = venueDetail[indexPath.row]
                cell.venueImage.image = nil
                cell.venueImage.contentMode = .scaleToFill
                if indexPath.row == 0 {
                    if let urlImage = URL(string: venue) {
                        cell.venueImage.kf.indicatorType = .activity
                        cell.venueImage.kf.setImage(with: urlImage, placeholder: UIImage.init(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: { (image, error, cache, url) in
                            //cell.venueImage.setNeedsLayout()
                            cell.layoutIfNeeded()
                            cell.detailDescriptionLabel.text = nil
                        })
                    }
                } else {
                    cell.detailDescriptionLabel.text = venue
                }
//                cell.venueImage.setNeedsLayout()
                cell.layoutIfNeeded()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
