//
//  String+Extenstion.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import Foundation

extension String {
    func asCoord() -> Coord? {
        let trimmedString = self.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
        let components = trimmedString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        if let lat = Double(components.first ?? ""), let lon = Double(components.last ?? "") {
            return Coord(lat: lat, lon: lon)
        } else {
            return nil
        }
    }
}
