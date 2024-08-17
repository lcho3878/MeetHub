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
        let passwordInput: ControlProperty<String>
        let validButtonTap: ControlEvent<Void>
        let signupButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let validationOutput: PublishSubject<String>
        let validationButtonEnabled: BehaviorSubject<Bool>
        let signupButtonEnabled: BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let validationOutput = PublishSubject<String>()
        let validationButtonEnabled = BehaviorSubject(value: false)
        let signupButtonEnabled = BehaviorSubject(value: false)
        
        input.emailInput
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
            .bind { _ in
                print("회원가입 클릭")
            }
            .disposed(by: disposeBag)
        
        return Output(validationOutput: validationOutput, validationButtonEnabled: validationButtonEnabled, signupButtonEnabled: signupButtonEnabled)
    }
}
