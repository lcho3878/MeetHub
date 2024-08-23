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
    
    func lookupPosts() -> Single<PostsResponseModel> {
        return Single.create { single -> Disposable in
            do {
                let request = try Router.lookUpPost.asURLRequest()
                AF.request(request)
                    .validate(statusCode: 200..<300)
                    .responseString{ response in
                        switch response.result {
                        case .success(let v):
//                            single(.success(v))
                            print(v)
                        case .failure(let e):
//                            single(.failure(e))
                            print(e)
                        }
                    }
            }
            catch {
                print("error")
            }
            return Disposables.create()
        }
    }
    
    func callRequest<T:Decodable>(api: Router, type: T.Type, hander: ((Error) -> Void)? = nil)  -> Single<T> {
        return Single.create { single -> Disposable in
            func loop() {
                do {
                    let request = try api.asURLRequest()
                    AF.request(request)
                        .validate(statusCode: 200..<300)
                        .responseDecodable(of: T.self) { response in
                            if response.response?.statusCode == 419 {
                                print("토큰갱신 필요")
                                self.refreshToken { result in
                                    switch result {
                                    case .success(_):
                                        loop()
                                    case .failure(let failure):
                                        hander?(failure)
                                    }
                                }
                            }
                            else {
                                switch response.result {
                                case .success(let v):
                                    single(.success(v))
                                case .failure(let e):
                                    single(.failure(e))
                                }
                            }
                        }
                }
                catch {
                    print("error")
                }
            }
            loop()
            return Disposables.create()
        }
    }
    
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let request = try Router.refresh.asURLRequest()
            AF.request(request)
                .responseDecodable(of: RefreshModel.self) { response in
//                    print(response.response?.statusCode)
                    switch response.result {
                    case .success(let success):
                        UserDefaultsManager.shared.token = success.accessToken
                        print("토근 갱신 완료")
                        completion(.success(()))
                        
                    case .failure(let error):
//                        print("Error발생: \(response.response?.statusCode)")
                        completion(.failure(error))
                    }
                }
        }
        catch {
            print("error")
        }
    }
    
    func uploadFiles(datas: [Data]) -> Single<FilesModel> {
        return Single.create { single -> Disposable in
            let url = Router.refresh.baseURL + "/posts/files"
            let header: HTTPHeaders = [
                Header.sesacKey.rawValue: Key.key,
                Header.contentType.rawValue: Header.multipart.rawValue,
                Header.authorization.rawValue: UserDefaultsManager.shared.token
            ]
            
            AF.upload(multipartFormData: { multipartFormData in
                for (i, data) in datas.enumerated() {
                    multipartFormData.append(data, withName: "files", fileName: "\(i).png", mimeType: "image/png")
                }
                
            }, to: url, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: FilesModel.self) { response in
                switch response.result {
                case .success(let value):
                    single(.success(value))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
}

