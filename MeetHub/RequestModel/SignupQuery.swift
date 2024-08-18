//
//  SignupQuery.swift
//  MeetHub
//
//  Created by 이찬호 on 8/18/24.
//

import Foundation

struct SignupQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}
