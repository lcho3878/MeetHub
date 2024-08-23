//
//  ProfileView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import UIKit
import SnapKit

final class ProfileView: BaseView {
    
    private let profileImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let profileNameLabel = {
        let view = UILabel()
        view.text = "닉네임 들어갈 자리"
        return view
    }()
    
    let myprofileButton = {
        let view = UIButton()
        view.setTitle("내 프로필 조회", for: .normal)
        view.backgroundColor = .systemBlue
        return view
    }()
    
    let logoutButton = {
        let view = UIButton()
        view.setTitle("로그아웃", for: .normal)
        view.backgroundColor = .systemRed
        return view
    }()
    
    override func setupViews() {
        addSubview(myprofileButton)
        addSubview(logoutButton)
        
        myprofileButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(myprofileButton.snp.bottom).offset(8)
            $0.centerX.equalTo(myprofileButton)
        }
        
        addSubview(profileImageView)
        addSubview(profileNameLabel)
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(8)
            $0.size.equalTo(50)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
    }
    
    func configureData(_ data: User) {
        profileNameLabel.text = data.nick
        if let profileImage = data.profileImage {
            APIManager.shared.requestImageData(image: profileImage) { [weak self] data in
                self?.profileImageView.image = UIImage(data: data)
            }
        }
    }
}
