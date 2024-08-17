//
//  Router.swift
//  MeetHub
//
//  Created by 이찬호 on 8/16/24.
//

import Foundation
import Alamofire

enum Router {
    case login(query: LoginQuery)
    case emailValidation(query: EmailQuery)
    case refresh
}

extension Router: TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .emailValidation:
            return .post
        case .refresh:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .emailValidation:
            return "/validation/email"
        case .refresh:
            return "/auth/refresh"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login, .emailValidation:
            return [
                Header.sesacKey.rawValue: Key.key,
                Header.contentType.rawValue: Header.json.rawValue
            ]
        case .refresh:
            return [:]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .login(let query):
            return try? JSONEncoder().encode(query)
        case .emailValidation(let query):
            return try? JSONEncoder().encode(query)
        case .refresh:
            return nil
        }
    }

}


