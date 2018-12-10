//
//  DateExtension.swift
//  KryProgrammingAssignment
//
//  Created by Mert Avci on 2018-12-07.
//  Copyright © 2018 MertAvci. All rights reserved.
//

import Foundation


extension Date {

    static func getFormatedTime(date: Date) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
