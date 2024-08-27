//
//  User.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import Foundation

struct User: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let posts: [String]
}
