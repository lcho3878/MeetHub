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
    }
    
    func transform(input: Input) -> Output {
        let queryInput = Observable.combineLatest(input.emailInput, input.passwordInput)
        input.loginButtonTap
            .withLatestFrom(queryInput)
            .map {
                LoginQuery(email: $0.0, password: $0.1)
            }
            .flatMap {
                APIManager.shared.createLogin(query: $0)
            }
            .bind(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
        
        
        
        return Output(loginButtonTap: input.loginButtonTap, signButtonTap: input.signButtonTap)
    }
}
