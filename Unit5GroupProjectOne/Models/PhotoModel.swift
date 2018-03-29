//
//  PhotoModel.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

struct AllPhotos: Codable {
    let response: Response
}

struct Response: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let items: [Photo]
}

struct Photo: Codable {
    let id: String
    let prefix: String
    let suffix: String
    let width: Int
    let height: Int
}
