//
//  APIManager.swift
//  MeetHub
//
//  Created by 이찬호 on 8/16/24.
//

import Foundation
import Alamofire
import RxSwift

final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func createLogin(query: LoginQuery) -> Single<LoginModel> {
        return Single.create { single -> Disposable in
            do {
                let request = try Router.login(query: query).asURLRequest()
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LoginModel.self) { result in
                        switch result.result {
                        case .success(let v):
                            single(.success(v))
                        case .failure(let e):
                            single(.failure(e))
                        }
                    }
            }
            catch {
              print("Error")
            }
            return Disposables.create()
        }
        
    }
}

