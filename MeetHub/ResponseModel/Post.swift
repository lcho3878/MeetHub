//
//  Post.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import Foundation

struct Post: Decodable, ResponseModel {
    let post_id: String
//    let product_id: String
    let title: String
    let content: String
    let content1: String? //좌표
    let content2: String? // 장소 이름(네이버)
    let content3: String? // 도로명 주소?
    let content4: String?
    let content5: String?
    let creator: Creator
    let createdAt: String
    let files: [String]
    let likes: [String]
    let hashTags: [String]?
    
    struct Creator: Decodable {
        let user_id: String
        let nick: String
        let profileImage: String?
    }
    
    var isMyPost: Bool {
        return creator.user_id == UserDefaultsManager.shared.userID
    }
    
    var dateLabelText: String? {
        return createdAt.isoStringToDate()?.dateToString(format: "yyyy일 MM월 dd일")
    }
    
    var isLiked: Bool {
        return likes.contains(UserDefaultsManager.shared.userID)
    }
    
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
            case 410: return "삭제된 게시글입니다."
            default: return "\(responseCode)"
            }
        }
    }
}
