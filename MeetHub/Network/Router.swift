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
    case myProfile
    case editProfile(query: ProfileEditQuery)
    case uploadFiles(files: [Data]?)
}

extension Router: TargetType {
    var baseURL: String {
        return Key.baseURL + "v1"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .emailValidation, .signUp, .uploadPost, .uploadFiles:
            return .post
        case .refresh, .lookUpPost, .image, .detailPost, .myProfile:
            return .get
        case .editProfile:
            return .put
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
        case .myProfile, .editProfile:
            return "/users/me/profile"
        case .uploadFiles:
            return "/posts/files"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login, .emailValidation, .signUp:
            return [
                Header.sesacKey.rawValue: Key.key,
                Header.contentType.rawValue: Header.json.rawValue
            ]
        case .lookUpPost, .image, .detailPost, .myProfile:
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
        case .editProfile, .uploadFiles:
            return [
                Header.authorization.rawValue: UserDefaultsManager.shared.token,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.sesacKey.rawValue: Key.key
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
    
    var multipart: MultipartFormData? {
        switch self {
        case .editProfile(let query):
            let multipart = MultipartFormData()
            let nick = query.nick.data(using: .utf8) ?? Data()
            let image = query.profile ?? Data()
            multipart.append(nick, withName: "nick")
            multipart.append(image, withName: "profile", fileName: "Image.png", mimeType: "image/png")
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


