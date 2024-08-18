//
//  SignupView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import UIKit
import SnapKit

final class SignupView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.borderStyle = .roundedRect
      
        let button = RoundButton(title: "중복 확인")
        textField.rightView = button
        textField.rightViewMode = .always
        return textField
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let signUpButton = RoundButton(title: "가입하기")
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(nicknameTextField)
        addSubview(passwordTextField)
        addSubview(signUpButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.left.right.equalTo(emailTextField)
            $0.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            $0.left.right.equalTo(emailTextField)
            $0.height.equalTo(44)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(40)
            $0.left.right.equalTo(emailTextField)
            $0.height.equalTo(44)
        }
    }
    
}
