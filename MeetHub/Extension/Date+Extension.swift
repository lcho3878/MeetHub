//
//  Date+Extension.swift
//  MeetHub
//
//  Created by 이찬호 on 8/26/24.
//

import Foundation

extension Date {

    static let formatter = DateFormatter()
    
    func dateToString(format: String) -> String {
        let formatter = Date.formatter
        formatter.dateFormat = format
        let formattedDate = formatter.string(from: self)
        return formattedDate
    }
    
}
