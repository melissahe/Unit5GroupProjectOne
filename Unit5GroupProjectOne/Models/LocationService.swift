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
    func userLocationUpdatedToLocation(_ location: CLLocation)
    
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
    
    private var geocoder = CLGeocoder()
    
}

//MARK: - Helper Functions
extension LocationService {

    public func checkAuthorizationStatusAndLocationServices() -> (authorizationStatus: CLAuthorizationStatus, locationServicesEnabled: Bool) {
        
        if !CLLocationManager.locationServicesEnabled() {
            return (CLLocationManager.authorizationStatus(), false)
        } else {
            var status: CLAuthorizationStatus!
            
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse, .authorizedAlways:
                status = CLLocationManager.authorizationStatus()
                locationManager.startUpdatingLocation()
            case .notDetermined:
                status = .notDetermined
                locationManager.requestWhenInUseAuthorization()
            case .denied:
                status = .denied
                locationManager.stopUpdatingLocation()
            case .restricted:
                status = .restricted
                locationManager.stopUpdatingLocation()
            }
            
            return (status, true)
        }
        
    }
    
    public func getLatAndLong(fromLocation location: String, completionHandler: @escaping (Error?, (latitude: Double, longitude: Double)?) -> Void) {
        
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                completionHandler(error, nil)
                return
            }
            
            if let placemarks = placemarks {
                let placemark = placemarks.first!
                
                guard let location = placemark.location else {
                    completionHandler(error, nil)
                    return
                }
                
                completionHandler(nil, (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            }
            
        }
        
    }
    
    //to avoid having to import core location in the view controller
    public func locationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    //Melissa to do - change placeholder
    public func getCurrentLocation(fromUserCoordinate userCoordinate: CLLocationCoordinate2D, completionHandler: @escaping (String) -> Void) {
        
        geocoder.reverseGeocodeLocation(CLLocation.init(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)) { (placeMark, error) in
            print("\(placeMark?.first?.locality), \(placeMark?.first?.administrativeArea)")
            
            var location: String!
            
            if let placeMark = placeMark?.first {
                if let city = placeMark.locality {
                    location = city
                }
                if let state = placeMark.administrativeArea {
                    if let city = location {
                        completionHandler("\(city), \(state)")
                        return
                    } else {
                        completionHandler(state)
                        return
                    }
                }
            }
            if location == nil {
                completionHandler("Current Location")
            }
        }
    }
    
}

//MARK: - Location Manager Delegate Methods
//i'm not making the view controller conform to this delegate because there's some functions here that should be handled in the model, not the view controller; i'll make a separate custom delegate that can pass information from these delegate methods

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.userLocationUpdateFailed(withError: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       //what happens when the location service authorization status changes
            //maybe should have different pop ups based on what authorization status is
        delegate?.locationServiceAuthorizationStatusChanged(toStatus: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        if let location = location {
        
            delegate?.userLocationUpdatedToLocation(location)
        
            UserPreferences.manager.saveUserCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }

    }
    
}
