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
