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
    
    let menuTableView = {
        let view = UITableView()
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.id)
        view.rowHeight = 60
        return view
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(profileNameLabel)
        addSubview(menuTableView)
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(8)
            $0.size.equalTo(50)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        menuTableView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
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
