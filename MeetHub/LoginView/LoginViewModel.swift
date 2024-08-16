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
    
    struct LoginModel {
        let email: String
        let password: String
    }
    
    struct Input {
        let emailInput: ControlProperty<String>
        let passwordInput: ControlProperty<String>
        let loginButtonTap: ControlEvent<Void>
        let signButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let loginButtonTap: ControlEvent<Void>
        let signButtonTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        input.loginButtonTap
            .flatMap { _ in
                Observable.zip(input.emailInput, input.passwordInput)
            }
            .bind(onNext: { value1, value2 in
                print(value1, value2)
            })
            .disposed(by: disposeBag)
        
        
        
        return Output(loginButtonTap: input.loginButtonTap, signButtonTap: input.signButtonTap)
    }
}
