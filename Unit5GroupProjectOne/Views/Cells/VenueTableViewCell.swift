//
//  VenueTableViewCell.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

//Message by Melissa: the table view cell that will be used to display the search results and also the list of collected venues (like in your collections tab, you see all your saved collections. and then when you tap a collection view cell, it should segue to a table view of the venues you saved for that collection)

class VenueTableViewCell: UITableViewCell {

    lazy var venueImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    lazy var venueName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    lazy var categoryName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(displayP3Red: 0.537, green: 0.537, blue: 0.537, alpha: 1)
        label.font.withSize(15)
        label.numberOfLines = 0
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "VenueListCell")
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = .white
        setupViews()
    }
    private func setupViews() {
        let viewObjects = [venueName, venueImage, categoryName] as! [UIView]
        viewObjects.forEach{addSubview($0)}
        
        venueImage.snp.makeConstraints { (image) in
            image.height.width.equalTo(90)
            image.top.leading.equalTo(5)
        }
        venueName.snp.makeConstraints { (label) in
            label.top.equalTo(5)
            label.leading.equalTo(self.venueImage.snp.trailing).offset(5)
            label.trailing.equalTo(self.contentView.snp.trailing).offset(-5)
        }
        categoryName.snp.makeConstraints { (label) in
            label.top.equalTo(self.venueName.snp.bottom).offset(5)
            label.leading.equalTo(self.venueImage.snp.trailing).offset(5)
            label.trailing.equalTo(self.contentView.snp.trailing).offset(-5)
        }
        
    }
    
    public func configureCell(venue: Venue) {
        self.categoryName.text = venue.categories.map{$0.shortName}.joined(separator: " ,")
        self.venueName.text = venue.name
        self.venueImage.image = nil
        self.venueImage.kf.indicatorType = .activity
        ImageCache.default.retrieveImage(forKey: venue.id, options: nil){(image, cache) in
            if let image = image {
                self.venueImage.image = image
                return
            } else {
                self.venueImage.image = #imageLiteral(resourceName: "placeholder")
                
            }
        }
        PhotoAPIClient.manager.getPhotos(venue: venue.id, completion: { (photo) in
            if let photo = photo.first {
                let urlStr = "\(photo.prefix)\(photo.width)x\(photo.height)\(photo.suffix)"
                if let photoURL = URL(string: urlStr) {
                    self.venueImage.kf.setImage(with: photoURL, placeholder: UIImage.init(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: { (image, error, cache, url) in
                        if let image = image {
                            ImageCache.default.store(image, forKey: venue.id)
                        }
                        self.setNeedsLayout()
                    })
                    
                }
            }
        }, errorHandler: { (_) in
            self.venueImage.image = #imageLiteral(resourceName: "placeholder")
        })
    }

}
