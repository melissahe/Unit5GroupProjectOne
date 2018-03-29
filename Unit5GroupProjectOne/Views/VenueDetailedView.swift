//
//  VenueDetailedView.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

//Message by Melissa: this should have all the detailed information about the venues after selecting them from the from the search tab

class VenueDetailedView: UIView {
    
    //to do
        //set up initializers, etc.
        //set up properties - it should have at least these properties:

    lazy var VenueDetailTableView: UITableView = {
        let tv = UITableView()
        tv.register(VenueDetailedTableViewCell.self, forCellReuseIdentifier: "DetailCell")
        return tv
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
        addSubview(VenueDetailTableView)
        
        VenueDetailTableView.snp.makeConstraints { (tableView) in
            tableView.edges.equalTo(self)
        }
    }
    
}


