//
//  SignupViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignupViewModel: ViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let emailInput: ControlProperty<String>
        let nicknameInput: ControlProperty<String>
        let passwordInput: ControlProperty<String>
        let validButtonTap: ControlEvent<Void>
        let signupButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let validationOutput: PublishSubject<String>
        let validationButtonEnabled: BehaviorSubject<Bool>
        let signupButtonEnabled: BehaviorSubject<Bool>
        let signupModelOutput: PublishSubject<SignupModel>
    }
    
    func transform(input: Input) -> Output {
        let validationOutput = PublishSubject<String>()
        let validationButtonEnabled = BehaviorSubject(value: false)
        let signupButtonEnabled = BehaviorSubject(value: false)
        let signupModelOutput = PublishSubject<SignupModel>()
        
        let emailInput = input.emailInput.share()
        
        let queryInput = Observable.combineLatest(emailInput, input.passwordInput, input.nicknameInput)
        
        Observable.combineLatest(emailInput, input.nicknameInput, input.passwordInput)
            .map {
                !$0.0.isEmpty && !$0.1.isEmpty && !$0.2.isEmpty
            }
            .bind { isEnabled in
                signupButtonEnabled.onNext(isEnabled)
            }
            .disposed(by: disposeBag)
        
        emailInput
            .map {
                !$0.isEmpty
            }
            .bind { isEnabled in
                validationButtonEnabled.onNext(isEnabled)
            }
            .disposed(by: disposeBag)
        
        input.validButtonTap
            .withLatestFrom(input.emailInput)
            .map {
                EmailQuery(email: $0)
            }
            .flatMap {
                APIManager.shared.createEmailValidation(query: $0)
            }
            .bind(onNext: { value in
                validationOutput.onNext(value.message)
                signupButtonEnabled.onNext(value.responseCode == 200)
            })
            .disposed(by: disposeBag)
        
        input.signupButtonTap
            .withLatestFrom(queryInput)
            .map {
                SignupQuery(email: $0.0, password: $0.2, nick: $0.1)
            }
            .flatMap {
                APIManager.shared.createSignUp(query: $0)
                    .catch { error in
                        signupModelOutput.onNext(SignupModel.errorModel(responseCode: error.asAFError?.responseCode))
                        return Single<SignupModel>.never()
                    }
            }
            .bind { value in
                signupModelOutput.onNext(value)
            }
            .disposed(by: disposeBag)
        
        return Output(validationOutput: validationOutput, validationButtonEnabled: validationButtonEnabled, signupButtonEnabled: signupButtonEnabled, signupModelOutput: signupModelOutput)
    }
}
