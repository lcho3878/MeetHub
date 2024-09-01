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
    
    func callRequest<T:ResponseModel>(api: Router, type: T.Type, hander: ((Error) -> Void)? = nil)  -> Single<T> {
        return Single.create { single -> Disposable in
            func loop() {
                do {
                    let request = try api.asURLRequest()
                    let method: DataRequest
                    if let multipart = api.multipart {
                        method = AF.upload(multipartFormData: multipart, with: request)
                    }
                    else {
                        method = AF.request(request)
                    }
                    method
                        .validate(statusCode: 200..<300)
                        .responseDecodable(of: T.self) { response in
                            let statusCode = response.response?.statusCode
                            if statusCode == 419 {
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
                                case .failure(_):
                                    single(.failure(T.ErrorModel(responseCode: statusCode)))
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
                        print("토큰 갱신 Error발생: \(response.response?.statusCode)")
                        completion(.failure(error))
                    }
                }
        }
        catch {
            print("error")
        }
    }
    
    func requestImageData(image: String, completion: @escaping (Data) -> Void) {
        let url = Router.refresh.baseURL + Router.image(image: image).path
        let header: HTTPHeaders = [
            Header.sesacKey.rawValue: Key.key,
            Header.authorization.rawValue: UserDefaultsManager.shared.token
        ]
        
        AF.request(url, headers: header)
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data {
                        completion(data)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        
    }
    
    func deletePost(postID: String) {
        let api = Router.deletePost(postID: postID)
        do {
            let request = try api.asURLRequest()
            AF.request(request)
                .validate(statusCode: 200..<300)
                .response { response in
                    print(response.response?.statusCode)
                }
        }
        catch {
            print("error")
        }
    }
    
    func callRequestTest<T:ResponseModel>(api: Router, type: T.Type, hander: ((Error) -> Void)? = nil)  -> Single<T> {
        return Single.create { single -> Disposable in
            func loop() {
                do {
                    let request = try api.asURLRequest()
                    let method: DataRequest
                    if let multipart = api.multipart {
                        method = AF.upload(multipartFormData: multipart, with: request)
                    }
                    else {
                        method = AF.request(request)
                    }
                    method
                        .validate(statusCode: 200..<300)
                        .responseDecodable(of: T.self) { response in
                            let statusCode = response.response?.statusCode
                            if statusCode == 419 {
                                print("토큰갱신 필요")
                                self.refreshToken { result in
                                    switch result {
                                    case .success(_):
                                        loop()
                                    case .failure(let failure):
                                        #warning("refresh Token 만료시 핸들링 고민해보기")
                                        hander?(failure)
                                    }
                                }
                            }
                            else {
                                switch response.result {
                                case .success(let v):
                                    single(.success(v))
                                case .failure(let e):
//                                    single(.failure(response.response?.statusCode))
                                    single(.failure(T.ErrorModel(responseCode: statusCode)))
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
    
    func callTest<T:Decodable>(api: Router, type: T.Type) {
        do {
            let request = try api.asURLRequest()
            AF.request(request)
                .validate(statusCode: 200..<300)
                .responseString { result in
                    print(result.response?.statusCode)
                    switch result.result {
                    case .success(let v):
                        print(v)
                    case .failure(let e):
                        print("error: \(e)")
                    }
                }
        }
        catch {
            print("error")
        }
    }
        
}

