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
    
    struct Body: Encodable, Decodable {
        let like_status: Bool
    }
}
