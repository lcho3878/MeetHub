//
//  Post.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import Foundation

struct Post: Decodable {
    let post_id: String
    let product_id: String
    let title: String
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let content5: String
    let createdAt: String
}
