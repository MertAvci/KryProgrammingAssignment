//
//  NetworkUtils.swift
//  KryProgrammingAssignment
//
//  Created by Mert Avci on 2018-12-07.
//  Copyright © 2018 MertAvci. All rights reserved.
//

import Foundation

class NetworkUtils {

    static let session = URLSession(configuration: .default)


    class func getTask(baseURL: URL, paramenters: [String:String]? = nil, compleationHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask {
        var url = baseURL
        if let paramenters = paramenters {
            var queryItems = [URLQueryItem]()
            var components = URLComponents(string: baseURL.absoluteString)
            for paramenter in paramenters {
                queryItems.append(URLQueryItem(name: paramenter.key, value: paramenter.value))
            }
            components!.queryItems = queryItems
            url = components!.url!
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        return self.session.dataTask(with: request, completionHandler: compleationHandler)
    }
}
