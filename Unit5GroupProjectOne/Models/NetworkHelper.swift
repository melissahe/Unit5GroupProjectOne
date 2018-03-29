//
//  NetworkHelper.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//


//
//  NetworkHelper.swift
//  Unit4Week3Homework-StudentVersion
//
//  Created by C4Q on 1/6/18.
//  Copyright © 2018 C4Q . All rights reserved.
//
import Foundation
class NetworkHelper {
    private init() {}
    static let manager = NetworkHelper()
    let urlSession = URLSession(configuration: .default)
    func performDataTask(with urlRequest: URL, completionHandler: @escaping ((Data) -> Void), errorHandler: @escaping (Error) -> Void) {
        self.urlSession.dataTask(with: urlRequest){(data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                guard let data = data else {
                    errorHandler(AppError.noDataReceived)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    if let _ = error {
                        errorHandler(AppError.badStatusCode)
                    }
                    return
                }
                if let error = error {
                    let error = error as NSError
                    if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                        errorHandler(AppError.noInternetConnection)
                        return
                    } else {
                        errorHandler(AppError.other(rawError: error))
                        return
                    }
                }
                completionHandler(data)
            }
            }.resume()
    }
}
