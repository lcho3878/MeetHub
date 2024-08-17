//
//  EmailValidationModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import Foundation

struct EmailValidationModel: Decodable {
    let message: String
    var responseCode: Int?
}
