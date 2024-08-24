//
//  UserDefaultsManager.swift
//  MeetHub
//
//  Created by 이찬호 on 8/20/24.
//

import Foundation

final class UserDefaultsManager {
    private enum UserDefaultsKey: String {
        case access
        case refresh
        case userID
    }
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    var token: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.access.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.access.rawValue)
        }
    }
    var refreshToken: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.refresh.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.refresh.rawValue)
        }
    }
    
    var userID: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultsKey.userID.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.userID.rawValue)
        }
    }
    
    func login(_ loginModel: LoginModel) {
        UserDefaultsManager.shared.token = loginModel.accessToken
        UserDefaultsManager.shared.refreshToken = loginModel.refreshToken
        UserDefaultsManager.shared.userID = loginModel.user_id
    }
    
    func logout() {
        UserDefaultsManager.shared.token = ""
        UserDefaultsManager.shared.refreshToken = ""
        UserDefaultsManager.shared.userID = ""
    }
    
    
}
