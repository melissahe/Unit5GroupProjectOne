//
//  VenueTipModel.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

struct VenueTipModel: Codable, Equatable {
    var venue: Venue
    var tip: String?
    var imageData: Data
    static func ==(lhs: VenueTipModel, rhs: VenueTipModel) -> Bool {
        return lhs.venue.id == rhs.venue.id
    }
}
