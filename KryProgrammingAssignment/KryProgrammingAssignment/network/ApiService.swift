//
//  ApiService.swift
//  KryProgrammingAssignment
//
//  Created by Mert Avci on 2018-12-07.
//  Copyright © 2018 MertAvci. All rights reserved.
//

import Foundation

class ApiService {

    // MARK: Private Properties

    private var statusTimer: Timer?

    // MARK: public static Properties

    public static let sharedInstance = ApiService()


    var getServiceCallback: (() -> Void)?


    /**
     The different error we can get when calling methods in this class.

     - generic: A generic error.
     - noConnection: No internet connection.
     */
    enum Errors: Error {
        case offline
        case unAuthorized
        case generic
        case noConnection
        case unspportedMediaType
        case couldNotFind
        case notIdentified
        case unparsableData
        case couldNotGetFileSize
    }


    private init() {
        self.statusTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(checkStatus), userInfo: nil, repeats: true)
        self.statusTimer?.fire()
    }

    @objc private func checkStatus() {
        self.getAllServiceStatus() { (_, _) in

            self.getServiceCallback?()
        }
    }


    /**
     Get a list of services.

     - Parameters:
     - compleationHandler: Compleation handler that will be called when the operation finishes.
     - service: A `Service` object representing a list of services.
     - error: An enum of the type `Errors` that indicates why the request failed, or nil if the request was successful.
     */

    func getAllServiceStatus(completion: @escaping (_ services: [Service]?, _ error: Errors?) -> Void) {

        if let serviceList = ServiceStore.sharedInstance.storedServiceList {

            var resultList = [Service]()
            let getDataGroup = DispatchGroup()
            let _ = serviceList.map {

                var currentService = $0
                getDataGroup.enter()
                let task = NetworkUtils.getTask(baseURL: $0.baseURL, paramenters: nil) { data, response, error in
                    if let httpResponse = response as? HTTPURLResponse {
                        if case 200...299 = httpResponse.statusCode, let _ = data {
                            currentService.isAvailable = true
                        } else {
                            currentService.isAvailable = false
                        }
                        currentService.lastUpdate = Date()
                        resultList.append(currentService)
                        getDataGroup.leave()
                    }
                }
                task.resume()
            }
            getDataGroup.notify(queue: DispatchQueue.main) {
                ServiceStore.sharedInstance.storedServiceList = resultList
                completion(resultList, nil)
            }
        }
    }


    /**
     Get specific service.

     - Parameters:
     - compleationHandler: Compleation handler that will be called when the operation finishes.
     - service: A `Service` object representing a service.
     - error: An enum of the type `Errors` that indicates why the request failed, or nil if the request was successful.
     */

    func getServiceStatus(service: Service?, completion: @escaping (_ services: Service?, _ error: Errors?) -> Void) {

        if var newService = service {

            let task = NetworkUtils.getTask(baseURL: newService.baseURL, paramenters: nil) { data, response, error in
                guard error == nil else {
                    completion(nil, .couldNotFind)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if case 200...299 = httpResponse.statusCode, let _ = data {
                        newService.isAvailable = true
                    } else {
                        newService.isAvailable = false
                    }
                    newService.lastUpdate = Date()

                    if var storedList = ServiceStore.sharedInstance.storedServiceList {
                        storedList.append(newService)
                        ServiceStore.sharedInstance.storedServiceList = storedList
                    } else {
                        ServiceStore.sharedInstance.storedServiceList = [newService]
                    }
                    completion(service, nil)
                }
            }
            task.resume()
        }
    }
}
