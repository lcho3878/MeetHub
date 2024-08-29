//
//  LikeQuery.swift
//  MeetHub
//
//  Created by 이찬호 on 8/28/24.
//

import Foundation

struct LikeQuery: Encodable {
    let postID: String
    let body: Body
    
    struct Body: Codable, ResponseModel {
        let like_status: Bool
        
        struct ErrorModel: ResponseError {
            var responseCode: Int?
            
            init(responseCode: Int? = nil) {
                self.responseCode = responseCode
            }
            
            var errorMessage: String {
                switch responseCode {
                case 400: return "잘못된 요청입니다."
                case 401: return "인증할 수 없는 액세스 토큰입니다."
                case 403: return "Forbidden"
                case 410: return "게시글을 찾을 수 없습니다."
                default: return ""
                }
            }
        }
    }
}
