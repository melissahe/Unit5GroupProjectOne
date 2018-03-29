//
//  CollectionView.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

//Message by Melissa: This will be the custom view that will go into the collections tab! maybe this view can also be reused or another view could be in the add/create collection view?

class VenueCollectionView: UIView {
 
    //to do
    lazy var venueCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(VenueCollectionViewCell.self, forCellWithReuseIdentifier: "VenueCollectionCell")
        return cv
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
        backgroundColor = .white
        setupViews()
    }
    private func setupViews() {
        addSubview(venueCollectionView)
        venueCollectionView.snp.makeConstraints { (collection) in
            collection.top.bottom.trailing.leading.equalTo(self)
        }
    }
        //set up collection view in the lazy var - maybe the padding?
        //set up constraints
    
}
