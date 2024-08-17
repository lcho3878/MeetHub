//
//  LoginViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {

    private let loginView = LoginView()
    
    private let viewModel = LoginViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        let input = LoginViewModel.Input(emailInput: loginView.emailTextField.rx.text.orEmpty, passwordInput: loginView.passwordTextField.rx.text.orEmpty, loginButtonTap: loginView.loginButton.rx.tap, signButtonTap: loginView.signButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.signButtonTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SignupViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.loginModelOutput
            .bind(with: self, onNext: { owner, value in
                if value.responseCode != nil {
                    //에러. 팝업
                    owner.showAlert(content: value.errorMessage)
                }
                else {
                    //로그인후 화면전환 로직
                    owner.showAlert(content: "로그인 성공")
                }
            })
            .disposed(by: disposeBag)
    }

}

