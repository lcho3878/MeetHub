//
//  PostsResponseModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import Foundation

struct PostsResponseModel: Decodable, ResponseModel {
    let data: [Post]
    let next_cursor: String
    let responseCode: Int?
    
    init (responseCode: Int?) {
        self.data = []
        self.next_cursor = ""
        self.responseCode = responseCode
    }
    
    static func errorModel(responseCode: Int?) -> PostsResponseModel {
        return PostsResponseModel(responseCode: responseCode)
    }
    
    var errorMessage: String {
        switch responseCode {
        case 400: return "잘못된 요청입니다."
        case 401: return "인증할 수 없는 액세스 토큰입니다."
        case 403: return "Forbidden"
        case 419: return "액세스 토큰이 만료되었습니다."
        default: return ""
        }
    }
    
    
}
