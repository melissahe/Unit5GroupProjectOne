//
//  VenueCollectionViewCell.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

//Message by Melissa: this will be the collection view cell that will be used in the collections tab! this can also be reused (meaning inherited from) as the collection view cell

class VenueCollectionViewCell: UICollectionViewCell {
    
    lazy var venueCollectionImage: UIImageView = {
        let image = UIImageView()
        //default placeholder
        image.image = #imageLiteral(resourceName: "placeholder")
        
        return image
    }()
    lazy var venueName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.67, green: 0.07, blue: 0.50, alpha: 0.90)
        label.textColor = .white
        
        return label
    }()
    lazy var plusImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "plus")
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = .orange
        setupViews()
    }
    private func setupViews() {
        let viewObjects = [venueCollectionImage, venueName, plusImage] as [UIView]
        viewObjects.forEach{addSubview($0)}
        
        venueName.snp.makeConstraints { (label) in
            label.height.equalTo(self.contentView.snp.height).multipliedBy(0.25)
            label.bottom.leading.trailing.equalTo(self.contentView)
        }
        venueCollectionImage.snp.makeConstraints { (image) in
            image.top.leading.trailing.equalTo(self.contentView)
            image.bottom.equalTo(self.venueName.snp.top)
        }
        plusImage.snp.makeConstraints { (image) in
            image.center.equalTo(venueCollectionImage.snp.center)
        }
        
    }
    
    public func configureCell(withCollection collection: [VenueTipModel], andTitle title: String, adding: Bool) {
        if !adding {
            plusImage.isHidden = true
        }
        
        if !collection.isEmpty {
            let imageData = collection[0].imageData
            guard let image = UIImage(data: imageData) else {
                print("could not retrieve saved venue image")
                return
            }
            self.venueCollectionImage.image = image
        } else {
            self.venueCollectionImage.image = #imageLiteral(resourceName: "placeholder")
        }
        
        self.venueName.text = title
        
    }
}
