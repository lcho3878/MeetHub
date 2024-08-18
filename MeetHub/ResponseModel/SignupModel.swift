//
//  SignupModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/18/24.
//

import Foundation

struct SignupModel: Decodable, ResponseModel {
    let user_id: String
    let email: String
    let nick: String
    let responseCode: Int?
    
    init(responseCode: Int?) {
        self.user_id = ""
        self.email = ""
        self.nick = ""
        self.responseCode = responseCode
    }
    
    static func errorModel(responseCode: Int?) -> SignupModel {
        return SignupModel(responseCode: responseCode)
    }
    
    var errorMessage: String {
        switch responseCode {
        case 400: return "필수값(이메일, 비밀번호)을 채워주세요."
        case 409: return "이미 가입된 유저 입니다."
        default: return ""
        }
    }
    
    
}
