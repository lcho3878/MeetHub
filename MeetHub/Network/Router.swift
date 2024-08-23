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
    case signUp(query: SignupQuery)
    case lookUpPost
    case detailPost(postID: String)
    case uploadPost(query: PostQuery)
    case image(image: String)
    case refresh
}

extension Router: TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .emailValidation, .signUp, .uploadPost:
            return .post
        case .refresh, .lookUpPost, .image, .detailPost:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .emailValidation:
            return "/validation/email"
        case .signUp:
            return "/users/join"
        case .lookUpPost:
            return "/posts"
        case .uploadPost:
            return "/posts"
        case .refresh:
            return "/auth/refresh"
        case .image(let image):
            return "/\(image)"
        case .detailPost(let postID):
            return "/posts/\(postID)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login, .emailValidation, .signUp:
            return [
                Header.sesacKey.rawValue: Key.key,
                Header.contentType.rawValue: Header.json.rawValue
            ]
        case .lookUpPost, .image, .detailPost:
            return [
                Header.sesacKey.rawValue: Key.key,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
            ]
        case .uploadPost:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.contentType.rawValue: Header.json.rawValue,
                Header.sesacKey.rawValue: Key.key
                
            ]
        case .refresh:
            return [
                Header.sesacKey.rawValue: Key.key,
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.refresh.rawValue: UserDefaultsManager.shared.refreshToken
            ]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .lookUpPost: 
            return [
                URLQueryItem(name: "product_id", value: "MeetHub_meet"),
                URLQueryItem(name: "limit", value: "10")
            ]
        default: return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .login(let query):
            return try? JSONEncoder().encode(query)
        case .emailValidation(let query):
            return try? JSONEncoder().encode(query)
        case .signUp(query: let query):
            return try? JSONEncoder().encode(query)
        case .uploadPost(let query):
            return try? JSONEncoder().encode(query)
        default:
            return nil
        }
    }

}


