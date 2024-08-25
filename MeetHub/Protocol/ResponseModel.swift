//
//  ResponseModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import Foundation

protocol ResponseModel {
    static func errorModel(responseCode: Int?) -> Self
    
    var errorMessage: String { get }
}

protocol ResponseModelTest: Decodable {
    associatedtype ErrorModel: ResponseError
}

protocol ResponseError: Error {
    var responseCode: Int? { get }
    var errorMessage: String { get }
    
    init(responseCode: Int?)
}
