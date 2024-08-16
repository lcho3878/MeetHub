//
//  LoginModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/16/24.
//

import Foundation

struct LoginModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
    let responseCode: Int?
    
    init(responseCode: Int?) {
        self.user_id = ""
        self.email = ""
        self.nick = ""
        self.accessToken = ""
        self.refreshToken = ""
        self.responseCode = responseCode
    }
    
    static func errorModel(responseCode: Int?) -> LoginModel {
        return LoginModel(responseCode: responseCode)
    }
}

enum APIError: Error {
    case body
    case accessTokenError
}
