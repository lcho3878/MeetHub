//
//  APIManager.swift
//  MeetHub
//
//  Created by 이찬호 on 8/16/24.
//

import Foundation
import Alamofire

final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func createLogin(query: LoginQuery) {
        do {
            let request = try Router.login(query: query).asURLRequest()
            AF.request(request)
                .responseString { result in
                    switch result.result {
                    case .success(let v): print(v)
                    case .failure(let e): print(e)
                    }
                }
        }
        catch {
          print("Error")
        }
    }
}

