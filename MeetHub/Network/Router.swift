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
    case lookUpPost(next: String?)
    case detailPost(postID: String)
    case uploadPost(query: PostQuery)
    case image(image: String)
    case refresh
    case myProfile
    case editProfile(query: ProfileEditQuery)
    case uploadFiles(files: [Data]?)
    case hashTag(next: String?, hashTag: String?)
    case editPost(query: PostEditQuery)
    case deletePost(postID: String)
    case likePost(query: LikeQuery)
    case recommendPost(query: LikeQuery)
    case search(query: String)
    case userPost(next: String?, userID: String)
}

extension Router: TargetType {
    var baseURL: String {
        switch self {
        case .search:
            return NaverSearchAPI.baseURL
        default: return Key.baseURL + "v1"
        }
        
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .emailValidation, .signUp, .uploadPost, .uploadFiles, .likePost, .recommendPost:
            return .post
        case .refresh, .lookUpPost, .image, .detailPost, .myProfile, .hashTag, .search, .userPost:
            return .get
        case .editProfile, .editPost:
            return .put
        case .deletePost:
            return .delete
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
        case .detailPost(let postID), .deletePost(let postID):
            return "/posts/\(postID)"
        case .myProfile, .editProfile:
            return "/users/me/profile"
        case .uploadFiles:
            return "/posts/files"
        case .hashTag:
            return "/posts/hashtags"
        case .editPost(let query):
            return "/posts/\(query.postID)"
        case .likePost(let query):
            return "/posts/\(query.postID)/like"
        case .recommendPost(let query):
            return "/posts/\(query.postID)/like-2"
        case .search:
            return "v1/search/local.json"
        case .userPost(let next, let userID):
            return "/posts/users/\(userID)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login, .emailValidation, .signUp:
            return [
                Header.sesacKey.rawValue: Key.key,
                Header.contentType.rawValue: Header.json.rawValue
            ]
        case .lookUpPost, .image, .detailPost, .myProfile, .hashTag, .deletePost, .userPost:
            return [
                Header.sesacKey.rawValue: Key.key,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
            ]
        case .uploadPost, .editPost, .likePost, .recommendPost:
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
        case .editProfile, .uploadFiles:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.sesacKey.rawValue: Key.key
            ]
        case .search:
            return [
                Header.naverClientID.rawValue: NaverSearchAPI.clientID,
                Header.naverClientSecret.rawValue: NaverSearchAPI.secret
            ]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .lookUpPost(let next):
            return [
                URLQueryItem(name: "product_id", value: "MeetHub_meet"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "next", value: next)
            ]
            
        case .hashTag(let next, let hashTag):
            return [
                URLQueryItem(name: "product_id", value: "MeetHub_meet"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "next", value: next),
                URLQueryItem(name: "hashTag", value: hashTag)
            ]
        case .search(let query):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "display", value: "5")
            ]
        case .userPost(let next, let userID):
            return [
            URLQueryItem(name: "next", value: next)
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
        case .editPost(let query):
            return try? JSONEncoder().encode(query.query)
        case .likePost(let query), .recommendPost(let query):
            return try? JSONEncoder().encode(query.body)
        default:
            return nil
        }
    }
    
    var multipart: MultipartFormData? {
        switch self {
        case .editProfile(let query):
            let multipart = MultipartFormData()
            let nick = query.nick.data(using: .utf8) ?? Data()
            multipart.append(nick, withName: "nick")
            if let image = query.profile {
                multipart.append(image, withName: "profile", fileName: "Image.png", mimeType: "image/png")
            }
            return multipart
        case .uploadFiles(let files):
            let multipart = MultipartFormData()
            guard let files else { return multipart }
            for (i, file) in files.enumerated() {
//                guard let file else { continue }
                multipart.append(file, withName: "files", fileName: "\(i).png", mimeType: "image/png")
            }
            return multipart
        default: return nil
        }
    }

}


