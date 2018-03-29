//
//  VenueModel.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/21/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

/*
 Search Venue:
 https://api.foursquare.com/v2/venues/search?ll=40.7484,-73.9857&oauth_token=ZQSWSRCGU33XMP2KNS2BWUNUICV4JJQYQ2NJNUNRTT4SXEZT&v=20180118
 ----------------------------------
 Search Photo:
 https://api.foursquare.com/v2/venues/43695300f964a5208c291fe3/photos?&oauth_token=ZQSWSRCGU33XMP2KNS2BWUNUICV4JJQYQ2NJNUNRTT4SXEZT&v=20180118
 ----------------------------------
 getImage:
 "prefix": "https://igx.4sqi.net/img/general/",
 "suffix": "/26739064_mUxQ4CGrobFqwpcAIoX6YoAdH0xCDT4YAxaU6y65PPI.jpg",
 "width": 612,
 "height": 612,
 
 formula: prefix+width+"x"+height+suffix
 */

import Foundation

struct AllVenue: Codable {
    let responseVenue: ResponseVenue
   
    enum CodingKeys: String, CodingKey {
        case responseVenue = "response"
    }
}

struct ResponseVenue: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let id: String
    let name: String
    let contact: Contact
    let location: Location
    let categories: [Category]
}

struct Contact: Codable {
    let phone: String?
    let formattedPhone: String?
    let twitter: String?
    let instagram: String?
    let facebook: String?
    let facebookUsername: String?
    let facebookName: String?
}

struct Location: Codable {
    let address: String?
    let crossStreet: String?
    let lat: Double
    let lng: Double
    let distance: Double
    let postalCode: String?
    let cc: String
    let neighborhood: String?
    let city: String?
    let state: String
    let country: String
    let formattedAddress: [String]?
}

struct Category: Codable {
    let id: String
    let name: String
    let pluralName: String
    let shortName: String
    let icon: Icon
}

struct Icon: Codable {
    let prefix: String
    let suffix: String
}




