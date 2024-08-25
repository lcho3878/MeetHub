//
//  LoginViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let emailInput: ControlProperty<String>
        let passwordInput: ControlProperty<String>
        let loginButtonTap: ControlEvent<Void>
        let signButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let loginButtonTap: ControlEvent<Void>
        let signButtonTap: ControlEvent<Void>
        let loginModelOutput: PublishSubject<LoginModel>
        let errorOutput: PublishSubject<LoginModel.ErrorModel?>
    }
    
    func transform(input: Input) -> Output {
        let queryInput = Observable.combineLatest(input.emailInput, input.passwordInput)
        let loginModelOutput = PublishSubject<LoginModel>()
        let errorOutput = PublishSubject<LoginModel.ErrorModel?>()
        
        
        input.loginButtonTap
            .withLatestFrom(queryInput)
            .map {
                LoginQuery(email: $0.0, password: $0.1)
            }
            .flatMap {
                APIManager.shared.callRequestTest(api: .login(query: $0), type: LoginModel.self)
                    .catch { error in
                        errorOutput.onNext(error as? LoginModel.ErrorModel)
                        return Single<LoginModel>.never()
                    }
            }
            .bind(onNext: { value in
                UserDefaultsManager.shared.login(value)
                loginModelOutput.onNext(value)
            })
            .disposed(by: disposeBag)
        
        
        
        return Output(loginButtonTap: input.loginButtonTap, signButtonTap: input.signButtonTap, loginModelOutput: loginModelOutput, errorOutput: errorOutput)
    }
}
