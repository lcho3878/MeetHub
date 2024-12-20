//
//  ProfileEditView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import UIKit
import SnapKit

final class ProfileEditView: BaseView {
    
    let profileImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        return view
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let editButton = RoundButton(title: "수정하기")
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageView.makeRound()
    }
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(nicknameTextField)
        addSubview(editButton)
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(44)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(nicknameTextField)
            $0.height.equalTo(44)
        }
    }
    
    func configureData(_ data: User) {
        print("업데이트")
        if let profileImage = data.profileImage {
            APIManager.shared.requestImageData(image: profileImage) { [weak self] data in
                self?.profileImageView.image = UIImage(data: data)
            }
        }
        
        nicknameTextField.text = data.nick
    }
}
