//
//  LocationService.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/21/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    
    func locationServiceAuthorizationStatusChanged(toStatus status: CLAuthorizationStatus)
    func userLocationUpdateFailed(withError error: Error)
    
}

class LocationService: NSObject {
    
    //singleton implementation
    override private init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //shouldn't "start updating location" unless the authorization status is authorized
    }
    
    public static let manager = LocationService()
    
    public weak var delegate: LocationServiceDelegate?
    
    private var locationManager: CLLocationManager!
    
}

//MARK: - Helper Functions
extension LocationService {
    
    //should be called in the view controller every view did appear, so we can present the right alerts
    public func checkAuthorizationStatusAndLocationServices() -> (authorizationStatus: CLAuthorizationStatus, locationServicesOn: Bool) {
        
        if !CLLocationManager.locationServicesEnabled() {
            return (CLLocationManager.authorizationStatus(), false)
        } else {
            var status: CLAuthorizationStatus!
            
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways:
                status = CLLocationManager.authorizationStatus()
                locationManager.stopUpdatingLocation()
            case .notDetermined:
                status = .notDetermined
                locationManager.requestWhenInUseAuthorization()
            case .denied:
            //to do - ask them to turn on location services? direct them to settings app lol
                status = .denied
                locationManager.stopUpdatingLocation()
            case .restricted:
                status = .restricted
                locationManager.stopUpdatingLocation()
            }
            
            return (status, true)
        }
        
    }
}

//MARK: - Location Manager Delegate Methods
//i'm not making the view controller conform to this delegate because there's some functions here that should be handled in the model, not the view controller; i'll make a separate custom delegate that can pass information from these delegate methods
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //to do - should probably have a custom delegate that gets called and presents an alert in the view controller saying that there was an error, could not get current location?
        
        delegate?.userLocationUpdateFailed(withError: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       //what happens when the location service authorization status changes
            //maybe should have different pop ups based on what authorization status is
        delegate?.locationServiceAuthorizationStatusChanged(toStatus: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        
        //to do:
            //set up user preferences
            //save the location in user preferences as the last known current location
    }
    
}
