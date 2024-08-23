//
//  ProfileEditQuery.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import Foundation

struct ProfileEditQuery: Encodable {
    let nick: String
    let profile: Data?
}
