//
//  SearchViewController.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/18/18.
//  Copyright © 2018 C4Q. All rights reserved.
//
import UIKit
import SnapKit
import MapKit

class SearchViewController: UIViewController {
    
    var numberOfLaunches: Int = 0
    
    let cellSpacing: CGFloat = UIScreen.main.bounds.width * 0.02
    
    let searchView = SearchView()
    
    lazy var venueSearchBarController = UISearchController(searchResultsController: nil)
    
    var venues: [Venue] = [] {
        didSet {
            searchView.venueCollectionView.reloadData()
            var annotations: [MKAnnotation] = []
            for venue in venues {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
                annotation.title = venue.name
                annotation.subtitle = venue.categories.map{$0.shortName}.joined(separator: ", ")
                annotations.append(annotation)
            }
            searchView.mapView.removeAnnotations(self.annotations)
            self.annotations = annotations
        }
    }
    
    var annotations: [MKAnnotation] = [] {
        didSet {
            searchView.mapView.addAnnotations(annotations)
            searchView.mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constrainView()
        configureNavBar()
        delegateAndDataSource()
        setUpLocationServices()
        let textFieldInsideSearchBar = searchView.locationSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(displayP3Red: 0.67, green: 0.07, blue: 0.50, alpha: 1)
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let _ = LocationService.manager.checkAuthorizationStatusAndLocationServices()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        self.navigationItem.searchController?.searchBar.endEditing(true)
    }
}

//MARK: - Helper Functions
extension SearchViewController {
    
     func configureNavBar() {
        //TODO: Edit title
        navigationItem.title = "Venue Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        venueSearchBarController.searchBar.delegate = self
        navigationItem.searchController = venueSearchBarController
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.searchController?.searchBar.tintColor = UIColor(displayP3Red: 0.67, green: 0.07, blue: 0.50, alpha: 1)
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController?.isActive = true
        navigationItem.searchController?.searchBar.placeholder = "Search for a venue"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "tableview icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(venueListButton))
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.67, green: 0.07, blue: 0.50, alpha: 1)
            //UIColor(red: 0.820, green: 0.656, blue: 0.545, alpha: 1) //dark orange
            //UIColor(red: 0.975, green: 0.868, blue: 0.775, alpha: 1) //light orange
    }
    
    @objc private func venueListButton() {
        let modalVC = VenueListViewController(navTitle: "Search Results", venues: self.venues)
        let navController = UINavigationController(rootViewController: modalVC)
        modalVC.view.backgroundColor = .white        
        self.present(navController, animated: true, completion: nil)
    }
    
     func delegateAndDataSource() {
        navigationItem.searchController?.searchBar.delegate = self
        searchView.locationSearchBar.delegate = self
        searchView.venueCollectionView.delegate = self
        searchView.venueCollectionView.dataSource = self
        LocationService.manager.delegate = self
        searchView.mapView.delegate = self
        searchView.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "mapAnnotationView")
        
    }
    
     private func constrainView() {
        view.addSubview(searchView)
        searchView.backgroundColor = .gray
        searchView.snp.makeConstraints { (view) in
            view.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
     func setUpLocationServices() {
        let locationService = LocationService.manager.checkAuthorizationStatusAndLocationServices()
        
        if locationService.locationServicesEnabled {
            switch locationService.authorizationStatus {
            case .denied:
                presentSettingsAlertController(withTitle: "Location Services Not Enabled", andMessage: "Please enable Location Services in Settings for better search results.")
            case .restricted:
                let alertController = UIAlertController(title: "Warning", message: "This app is not authorized to use location services.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            default:
                //stuff that you might want to happen if the app starts and the user access is on
                break
            }
        }
        
        
    }
     func presentSettingsAlertController(withTitle title: String?, andMessage message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (_) in
            
            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
     func createAlertController(withTitle title: String?, andMessage message: String?) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        return alertController
    }
    
     func getVenues(fromSearchTerm searchTerm: String, latitude: Double, andLongitude longitude: Double) {
        VenueAPIClient.manager.getVenues(lat: latitude, lon: longitude, search: searchTerm, completion: { (venues) in
            if venues.isEmpty {
                print("It's empty!!!")
                
                //present the "no results" alert
                let alertController = self.createAlertController(withTitle: "No Results", andMessage: "Please try again with a different search term or location.")
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            print(venues)
            self.venues = venues
        }, errorHandler: { (error) in
            
            //TODO: Present the alert
            let alertController = self.createAlertController(withTitle: "Error", andMessage: "An error occurred:\nRate Limit has been exceeded.\n\(error)")
            self.present(alertController, animated: true, completion: nil)
            
        })
    }
}

//MARK: - Collection View Delegate Flow Layout Methods
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 4.5
        let numberOfSpaces: CGFloat = numberOfCells + 1
        let width = (collectionView.bounds.width - (numberOfSpaces * cellSpacing)) / numberOfCells
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
}

//MARK: - Collection View Delegate and Data Source Methods
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAnnotation = annotations[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath)
        let center = CLLocationCoordinate2D(latitude: selectedAnnotation.coordinate.latitude, longitude: selectedAnnotation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        searchView.mapView.setRegion(region, animated: true)
        searchView.mapView.selectAnnotation(selectedAnnotation, animated: true)
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) }, completion: { finished in
                UIView.animate(withDuration: 0.06, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseIn, animations: { cell?.transform = CGAffineTransform(scaleX: 1, y: 1) }, completion: nil )})
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let venue = venues[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionCell", for: indexPath) as! SearchCollectionViewCell
        cell.configureCell(withVenue: venue)
        cell.layer.cornerRadius = cell.bounds.size.width / 2
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 1
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 7
        cell.layer.masksToBounds = true
        cell.contentView.backgroundColor = .clear
        return cell
    }
}


