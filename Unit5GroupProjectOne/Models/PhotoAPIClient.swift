//
//  PhotoAPIClient.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import Alamofire
class PhotoAPIClient {
    private init() {}
    static let manager = PhotoAPIClient()
    func getPhotos(venue venueId: String,
                   completion: @escaping ([Photo]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let urlBase = "https://api.foursquare.com/v2/venues/\(venueId)/photos"
        let dateFormatted = DateFormatter()
        let date = Date()
        dateFormatted.dateFormat = "yyyyMMdd"
        let strDate = dateFormatted.string(from: date)
        let params: [String: Any] = ["client_id": APIKeys.userId,
                                     "client_secret": APIKeys.userPwd,
                                     "limit": 10,
                                     "v": strDate]
        Alamofire.request(urlBase, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            switch dataResponse.result {
            case .failure(let error):
                print("Response error: \(error.localizedDescription)")
                errorHandler(error)
            case .success:
                if let error = dataResponse.error {
                    print("Network error: \(error.localizedDescription)")
                } else if let data = dataResponse.data {
                    do {
                        let decoder = JSONDecoder()
                        let results = try decoder.decode(AllPhotos.self, from: data)
                        completion(results.response.photos.items)
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
