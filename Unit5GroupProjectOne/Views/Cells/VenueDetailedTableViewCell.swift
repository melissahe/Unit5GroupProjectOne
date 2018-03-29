//
//  VenueDetailedTableViewCell.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class VenueDetailedTableViewCell: UITableViewCell {
    //some labels that have info/description about the venue
    //add constraints
    
    
    lazy var venueImage: UIImageView = {
        let venueImage = UIImageView()
        return venueImage
    }()
    
    lazy var detailDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "DetailCell")
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
        addSubview(venueImage)
        addSubview(detailDescriptionLabel)
        
        venueImage.snp.makeConstraints { (image) in
            image.edges.equalTo(self)
        }
        detailDescriptionLabel.snp.makeConstraints { (label) in
            label.trailing.leading.equalTo(self).inset(8)
            label.centerY.equalTo(self)
            label.height.equalTo(80)
        }
    }
}
