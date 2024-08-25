//
//  LoginModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/16/24.
//

import Foundation

struct LoginModel: Decodable, ResponseModelTest {
    let user_id: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String

    struct ErrorModel: ResponseError {
        var responseCode: Int?
        
        init(responseCode: Int? = nil) {
            self.responseCode = responseCode
        }
        
        var errorMessage: String {
            switch responseCode {
            case 400: return "필수값(이메일, 비밀번호)을 채워주세요."
            case 401: return "계정, 비밀번호를 확인해주세요."
            default: return ""
            }
        }
    }
}


