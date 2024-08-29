//
//  ResponseModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import Foundation

protocol ResponseModel: Decodable {
    associatedtype ErrorModel: ResponseError
}

protocol ResponseError: Error {
    var responseCode: Int? { get }
    var errorMessage: String { get }
    
    init(responseCode: Int?)
}
