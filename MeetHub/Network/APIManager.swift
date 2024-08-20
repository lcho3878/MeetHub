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
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
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
    
    func createEmailValidation(query: EmailQuery) -> Single<EmailValidationModel> {
        return Single.create { single -> Disposable in
            do {
                let request = try Router.emailValidation(query: query).asURLRequest()
                AF.request(request)
                    .responseDecodable(of: EmailValidationModel.self) { response in
                        switch response.result {
                        case .success(var v):
                            v.responseCode = response.response?.statusCode
                            single(.success(v))
                        case .failure(let e):
                            single(.failure(e))
                        }
                    }
            }
            catch {
                print("error")
            }
            return Disposables.create()
        }
    }
    
    func createSignUp(query: SignupQuery) -> Single<SignupModel> {
        return Single.create { single -> Disposable in
            do {
                let request = try Router.signUp(query: query).asURLRequest()
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: SignupModel.self) { response in
                        switch response.result {
                        case .success(var v):
                            single(.success(v))
                        case .failure(let e):
                            single(.failure(e))
                        }
                    }
            }
            catch {
                print("error")
            }
            return Disposables.create()
        }
    }
    
    func lookupPosts() -> Single<PostsResponseModel> {
        return Single.create { single -> Disposable in
            do {
                let request = try Router.lookUpPost.asURLRequest()
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: PostsResponseModel.self) { response in
                        switch response.result {
                        case .success(var v):
                            single(.success(v))
                        case .failure(let e):
                            single(.failure(e))
                        }
                    }
            }
            catch {
                print("error")
            }
            return Disposables.create()
        }
    }
    
    func callRequest<T:Decodable>(api: Router, type: T.Type) -> Single<T> {
        return Single.create { single -> Disposable in
            do {
                let request = try api.asURLRequest()
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let v):
                            single(.success(v))
                        case .failure(let e):
                            single(.failure(e))
                        }
                    }
            }
            catch {
                print("error")
            }
            return Disposables.create()
        }
    }
}

