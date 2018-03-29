//
//  SearchView.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import MapKit

class SearchView: UIView {
    
    lazy var venueCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionCell")
        return cv
    }()
    
    //already made in the view controller
//    lazy var venueSearchBar: UISearchBar = {
//        let searchbar = UISearchBar()
//        searchbar.placeholder = "Search for a venue"
//        return searchbar
//    }()
    
    lazy var locationSearchBar: UISearchBar = {
        let searchbar = UISearchBar()
        searchbar.barTintColor = .white
        return searchbar
    }()
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.mapType = .standard
        return map
    }()
    
    lazy var userTrackingButton: MKUserTrackingButton = {
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        return trackingButton
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
        let viewObjects = [locationSearchBar, mapView, userTrackingButton, venueCollectionView] as [UIView]
        viewObjects.forEach{addSubview($0)}
        
        locationSearchBar.snp.makeConstraints { (location) in
            location.top.leading.trailing.equalTo(self)
            location.height.equalTo(40)
        }
        mapView.snp.makeConstraints { (map) in
            map.top.equalTo(locationSearchBar.snp.bottom)
            map.trailing.leading.bottom.equalTo(self)
        }
        venueCollectionView.snp.makeConstraints { (collection) in
            collection.bottom.equalTo(self).offset(-15)
            collection.trailing.leading.centerX.equalTo(self)
            collection.height.equalTo(self).multipliedBy(0.20)
        }
        userTrackingButton.snp.makeConstraints { (tracking) in
            tracking.top.equalTo(locationSearchBar.snp.bottom).offset(16)
            tracking.leading.equalTo(self).offset(16)
        }
    }

}
