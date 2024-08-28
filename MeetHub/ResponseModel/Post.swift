//
//  Post.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import Foundation

struct Post: Decodable {
    let post_id: String
//    let product_id: String
    let title: String
    let content: String
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let creator: Creator
    let createdAt: String
    let files: [String]
    let likes: [String]
    
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
}
