//
//  UserPreferences.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

class UserPreferences {
    private init() {}
    
    static let manager = UserPreferences()
    
    private let userDefaults = UserDefaults.standard
    private let userCoordinatesLatitudeKey = "User Coordinates Latitude Key"
    private let userCoordinatesLongitudeKey = "User Coordinates Longitude Key"
    private let searchCoordinatesLatitudeKey = "Search Coordinates Latitude Key"
    private let searchCoordinatesLongitudeKey = "Search Coordinates Longitude Key"
    
    //save
    public func saveUserCoordinates(latitude: Double, longitude: Double) {
        userDefaults.set(latitude, forKey: userCoordinatesLatitudeKey)
        userDefaults.set(longitude, forKey: userCoordinatesLongitudeKey)
        print("saved user coordinates!")
    }
    public func saveSearchCoordinates(latitude: Double, longitude: Double) {
        userDefaults.set(latitude, forKey: searchCoordinatesLatitudeKey)
        userDefaults.set(longitude, forKey: searchCoordinatesLongitudeKey)
        print("saved search coordinates!")
    }
    //get
    public func getUserCoordinate() -> (latitude: Double?, longitude: Double?) {
        let latitude = userDefaults.object(forKey: userCoordinatesLatitudeKey) as? Double
        let longitude = userDefaults.object(forKey: userCoordinatesLongitudeKey) as? Double
        return (latitude, longitude)
    }
    public func getSearchCoordinates() -> (latitude: Double?, longitude: Double?) {
        let latitude = userDefaults.object(forKey: searchCoordinatesLatitudeKey) as? Double
        let longitude = userDefaults.object(forKey: searchCoordinatesLatitudeKey) as? Double
        return (latitude, longitude)
    }
}
