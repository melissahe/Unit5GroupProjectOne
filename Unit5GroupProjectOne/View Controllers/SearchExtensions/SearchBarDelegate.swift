//
//  SearchBarDelegate.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//
import UIKit

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        guard
            let venueSearchText = venueSearchBarController.searchBar.text,
            !venueSearchText.isEmpty,
            let formattedVenueSearchText = venueSearchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else {
                
                let noVenuesAlert = createAlertController(withTitle: "No Search Term", andMessage: "Please enter a valid search term before searching.")
                self.present(noVenuesAlert, animated: true, completion: nil)
                
                return
        }
        
        guard
            let locationSearchText = searchView.locationSearchBar.text,
            !locationSearchText.isEmpty
            else {
                
                let locationService = LocationService.manager.checkAuthorizationStatusAndLocationServices()
                
                //if location services is enabled - do search
                if locationService.locationServicesEnabled && (locationService.authorizationStatus == .authorizedAlways || locationService.authorizationStatus == .authorizedWhenInUse) {
                    //if user location access is allowed
                    //do search
                    let userLocation = searchView.mapView.userLocation
                    getVenues(fromSearchTerm: formattedVenueSearchText, latitude: userLocation.coordinate.latitude, andLongitude: userLocation.coordinate.longitude)
                } else {
                    //if location services is not enabled - present alert controller
                    presentSettingsAlertController(withTitle: "Location Services Not Enabled", andMessage: "Please enable Location Services in Settings for better search results.")
                }
                return
        }
        
        //if user enters location
        LocationService.manager.getLatAndLong(fromLocation: locationSearchText) { (error, coordinate) in
            
            if let error = error {
                //present alert that says could not get coordinates from user inputted location
                let alertController = self.createAlertController(withTitle: "Error", andMessage: "Could not get coordinates from user-input location.\n\"\(error.localizedDescription)\"")
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            if let coordinate = coordinate {
                self.getVenues(fromSearchTerm: formattedVenueSearchText, latitude: coordinate.latitude, andLongitude: coordinate.longitude)
                UserPreferences.manager.saveSearchCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
        }
        searchBar.resignFirstResponder()
    }
}
