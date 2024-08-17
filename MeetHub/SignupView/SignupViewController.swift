//
//  SignupViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignupViewController: BaseViewController {
    
    private let signupView = SignupView()
    
    private let viewModel = SignupViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        guard let validButton = signupView.emailTextField.rightView as? RoundButton else { return }
        let input = SignupViewModel.Input(
            emailInput: signupView.emailTextField.rx.text.orEmpty,
            passwordInput: signupView.passwordTextField.rx.text.orEmpty,
            validButtonTap: validButton.rx.tap,
            signupButtonTap: signupView.signUpButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.validationOutput
            .bind(with: self) { owner, message in
                owner.showAlert(content: message)
            }
            .disposed(by: disposeBag)
        
        output.signupButtonEnabled
            .bind(with: self) { owner, isEnabled in
                owner.signupView.signUpButton.rx.isEnabled.onNext(isEnabled)
            }
            .disposed(by: disposeBag)
        
        output.validationButtonEnabled
            .bind{ isEnabled in
                validButton.rx.isEnabled.onNext(isEnabled)
            }
            .disposed(by: disposeBag)
    }
}
