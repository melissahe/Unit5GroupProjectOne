//
//  SearchCollectionViewCell.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

//Message by Melissa: this will be for the collection view that is seen in the search tab

class SearchCollectionViewCell: UICollectionViewCell {
    
    lazy var searchCellImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "placeholder")
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
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
        addSubview(searchCellImage)
        searchCellImage.snp.makeConstraints { (image) in
            image.edges.equalTo(self).multipliedBy(0.80)
            image.centerX.centerY.equalTo(self)
        }
    }
        //set up initializers (so that you can register them to collection views)
        //set up collection view properties and constraints
        //maybe add a "configure cell" function here that takes in some parameter and sets up the property for you, instead of having to do all that in the cellForItemAt datasource method in the view controller (to avoid cluttering the view controller, and having a cell that is more reusable)

    public func configureCell(withVenue venue: Venue) {
        ImageCache.default.retrieveImage(forKey: venue.id, options: nil){(image, cache) in
            if let image = image {
                self.searchCellImage.image = image
                return
            } else {
                self.searchCellImage.image = #imageLiteral(resourceName: "placeholder")
            }
        }
        
        PhotoAPIClient.manager.getPhotos(venue: venue.id, completion: { (photo) in
            if let photo = photo.first {
                let urlPhoto = "\(photo.prefix)\(photo.width)x\(photo.height)\(photo.suffix)"
                if let url = URL(string: urlPhoto) {
                    self.searchCellImage.kf.indicatorType = .activity
                    self.searchCellImage.kf.setImage(with: url, placeholder: UIImage.init(named: "placeholder-image"), options: nil, progressBlock: nil, completionHandler: { (image, error, cache, url) in
                    
                        if let image = image {
                        ImageCache.default.store(image, forKey: venue.id) 
                        }
                    })
                }
            }
        }, errorHandler: { (_) in
            self.searchCellImage.image = #imageLiteral(resourceName: "placeholder")
        })
    }
}
