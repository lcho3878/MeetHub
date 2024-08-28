//
//  Header.swift
//  MeetHub
//
//  Created by 이찬호 on 8/16/24.
//

import Foundation

enum Header: String {
    case authorization = "Authorization" // Token
    case sesacKey = "SesacKey"
    case refresh = "Refresh"
    case contentType = "Content-Type"
    case json = "application/json"
    case multipart = "multipart/form-data"
    case naverClientID = "X-Naver-Client-Id"
    case naverClientSecret = "X-Naver-Client-Secret"
}
