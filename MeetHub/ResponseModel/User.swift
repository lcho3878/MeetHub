//
//  User.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import Foundation

struct User: Decodable, ResponseModel {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let posts: [String]
    
    struct ErrorModel: ResponseError {
        var responseCode: Int?
        
        init(responseCode: Int? = nil) {
            self.responseCode = responseCode
        }
        
        var errorMessage: String {
            switch responseCode {
            case 401: return "인증할 수 없는 액세스 토큰입니다."
            case 400: return "파일의 제한사항과 맞지 않습니다. 5MB 이하"
            case 403: return "Forbidden"
            default: return ""
            }
        }
    }
}
