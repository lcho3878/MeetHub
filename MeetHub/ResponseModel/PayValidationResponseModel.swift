//
//  PayValidationResponseModel.swift
//  MeetHub
//
//  Created by 이찬호 on 9/2/24.
//

import Foundation

struct PayValidationResponseModel: Decodable {
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}
