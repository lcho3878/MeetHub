//
//  PostQuery.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import Foundation

struct PostQuery: Encodable {
    let title: String
    let content: String
    let content1: String?
    let product_id: String
    let files: [String]
}
