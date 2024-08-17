//
//  LoginModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/16/24.
//

import Foundation

struct LoginModel: Decodable, ResponseModel {
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
    
    var errorMessage: String {
        switch responseCode {
        case 400: return "필수값(이메일, 비밀번호)을 채워주세요."
        case 401: return "계정, 비밀번호를 확인해주세요."
        default: return ""
        }
    }
}
