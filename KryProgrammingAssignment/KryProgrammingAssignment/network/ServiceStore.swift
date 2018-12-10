//
//  ServiceStore.swift
//  KryProgrammingAssignment
//
//  Created by Mert Avci on 2018-12-07.
//  Copyright © 2018 MertAvci. All rights reserved.
//

import Foundation

protocol ServiceStoreProtocol {

    var storedServiceList: [Service]? { get set }
}

class ServiceStore: ServiceStoreProtocol {


    // MARK: Initializers

    private init() {}

    // MARK: Private Static Properties

    private static let services = "services"

    // MARK: Static Properties

    static let sharedInstance = ServiceStore()
    static let userDefaults = UserDefaults.standard

    var storedServiceList: [Service]? {
        get{
            if let serviceData = ServiceStore.userDefaults.object(forKey: ServiceStore.services) as? Data  {
                let decoder = JSONDecoder()
                let serviceList = try? decoder.decode([Service].self, from: serviceData)
                return serviceList
            }else {
                return nil
            }
        }
        set{
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(newValue) {
                 ServiceStore.userDefaults.set(encodedData, forKey: ServiceStore.services)
            }
        }
    }
}

