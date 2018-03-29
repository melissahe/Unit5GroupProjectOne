//
//  LocationServiceDelegate.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import MapKit

//MARK: - Location Service Delegate Methods
extension SearchViewController: LocationServiceDelegate {
    
    //Melissa to QA: Please check if this doesn't make the alert pop up too often! Thanks!!
    func locationServiceAuthorizationStatusChanged(toStatus status: CLAuthorizationStatus) {
        print(status)
        
        switch status {
        case .denied:
            if self.presentedViewController == nil {
                presentSettingsAlertController(withTitle: "Location Services Not Enabled", andMessage: "Please enable Location Services in Settings for better search results.")
            }
        case .restricted:
            let alertController = UIAlertController(title: "Warning", message: "This app is not authorized to use location services.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    func userLocationUpdateFailed(withError error: Error) {
        print(error)
        presentSettingsAlertController(withTitle: "Could Not Get User Location", andMessage: "Please enable Location Services in Settings or check network connectivity.")
    }
    
    func userLocationUpdatedToLocation(_ location: CLLocation) {
        let userCoordinates = searchView.mapView.userLocation.coordinate
        
        if numberOfLaunches == 0 {
            //let mapSpan = CLLocation(latitudeDelta: 40.743034, longitudeDelta: -73.941832)
            searchView.mapView.showsUserLocation = true
            //let userRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude), span: mapSpan)
            let regionRadius: CLLocationDistance = 10000
            let userRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius, regionRadius)
            searchView.mapView.setRegion(userRegion, animated: true)
            numberOfLaunches += 1
        }
        
        LocationService.manager.getCurrentLocation(fromUserCoordinate: userCoordinates, completionHandler: {(currentLocation) in
            self.searchView.locationSearchBar.placeholder = currentLocation
            self.searchView.locationSearchBar.layoutIfNeeded()
        })
    }
    
}
