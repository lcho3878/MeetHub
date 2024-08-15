//
//  LoginView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/15/24.
//

import UIKit
import SnapKit

final class LoginView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MeetHub"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.text = "gg@gg.gg"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.text = "1234"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let signButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입하러가기", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(signButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.left.right.equalTo(emailTextField)
            $0.height.equalTo(44)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(40)
            $0.left.right.equalTo(emailTextField)
            $0.height.equalTo(44)
        }
        
        signButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(40)
            $0.left.right.equalTo(emailTextField)
            $0.height.equalTo(44)
        }
        
    }
}
