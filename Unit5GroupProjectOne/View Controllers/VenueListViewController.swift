//
//  VenueListViewController.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit

//Message by Melissa: for the table view results that the user can also see when searching for venues

class VenueListViewController: UIViewController {

    var navTitle: String!
    
    //results
    var venues: [Venue]?
    
    //saved venues
    var savedVenues: [VenueTipModel]?
    
    lazy var venueListTableView: UITableView = {
        let tv = UITableView()
        tv.register(VenueTableViewCell.self, forCellReuseIdentifier: "VenueListCell")
        return tv
    }()
    init(navTitle: String, venues: [Venue]) {
        super.init(nibName: nil, bundle: nil)
        self.navTitle = navTitle
        self.venues = venues
    }
    init(navTitle: String, savedVenues: [VenueTipModel]) {
        super.init(nibName: nil, bundle: nil)
        self.navTitle = navTitle
        self.savedVenues = savedVenues
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        constrainTableView()
        venueListTableView.dataSource = self
        venueListTableView.delegate = self
        configureNavigation()
        venueListTableView.rowHeight = 97.5
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        venueListTableView.reloadData()
        if let venues = venues {
            let emptyView = EmptyView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
            if venues.isEmpty {
                emptyView.configureView(withText: "No Search Results Available Yet")
                self.view.addSubview(emptyView)
            } else {
                self.view.willRemoveSubview(emptyView)
            }
        }
        if let savedVenues = savedVenues {
            let emptyView = EmptyView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
            if savedVenues.isEmpty {
                emptyView.configureView(withText: "No Saved Venues Yet")
                self.view.addSubview(emptyView)
            } else {
                self.view.willRemoveSubview(emptyView)
            }
        }
    }
    
    private func constrainTableView() {
        view.addSubview(venueListTableView)
        venueListTableView.snp.makeConstraints { (view) in
            view.top.bottom.trailing.leading.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigation() {
        //Melissa: if this view controller is already embedded in a navigation controller, this is not needed, we can just push the venue detailed view on to the navigation stack
//        let venueNavigation = UINavigationController(rootViewController: VenueDetailedViewController())
        
        navigationController?.navigationBar.backgroundColor = .orange
        
        if venues != nil {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
            
        }
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 0.67, green: 0.07, blue: 0.50, alpha: 1)
        navigationItem.title = self.navTitle
    }
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)        
    }
    
}
extension VenueListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if savedVenues != nil {
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if savedVenues != nil {
            let collectionIndex = FileManagerHelper.manager.getCollections().index(where: {$0 == savedVenues!})
            if editingStyle == .delete {
                self.savedVenues?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                FileManagerHelper.manager.removeVenue(atVenueIndex: indexPath.row, fromCollectionIndex: collectionIndex!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Add array count
        if let venues = self.venues {
            return venues.count
        }
        
        return savedVenues!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var venue: Venue!
        
        if let venueArr = venues {
            venue = venueArr[indexPath.row]
        }
        if let savedVenues = savedVenues {
            venue = savedVenues[indexPath.row].venue
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VenueListCell", for: indexPath) as? VenueTableViewCell {
            cell.configureCell(venue: venue)
            cell.setNeedsLayout()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = VenueDetailedViewController()
        var venue: Venue!
        var tip: String!
        var saved: Bool!
        if let venues = venues {
            venue = venues[indexPath.row]
            saved = false
        }
        if let savedVenues = savedVenues {
            venue = savedVenues[indexPath.row].venue
            if let tipText = savedVenues[indexPath.row].tip {
                tip = tipText
            }
            saved = true
        }
        detailVC.configureView(venue: venue, tip: tip, saved: saved)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

