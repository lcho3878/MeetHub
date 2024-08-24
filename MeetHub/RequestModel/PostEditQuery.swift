//
//  PostEditQuery.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import Foundation

struct PostEditQuery: Encodable {
    let postID: String
    let query: PostQuery
}
