//
//  Service.swift
//  KryProgrammingAssignment
//
//  Created by Mert Avci on 2018-12-07.
//  Copyright © 2018 MertAvci. All rights reserved.
//

import Foundation

public struct Service: Codable {

    let baseURL : URL
    let name : String
    var isAvailable : Bool?
    var lastUpdate : Date?

    init(baseURL : URL, name : String, isAvailable : Bool?, lastUpdate: Date?) {
        self.baseURL = baseURL
        self.name = name
        self.isAvailable = isAvailable
        self.lastUpdate = lastUpdate
    }
}
