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
        view.clipsToBounds = true
        return view
    }()
    
    private let profileNameLabel = {
        let view = UILabel()
        view.text = "닉네임 들어갈 자리"
        view.font = .boldSystemFont(ofSize: 24)
        return view
    }()
    
    private let emailLabel = {
        let view = UILabel()
        view.text = "gg@gg.gg"
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    private let userStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    let menuTableView = {
        let view = UITableView()
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.id)
        view.rowHeight = 60
        view.backgroundColor = AppColor.beige
        return view
    }()
    
    var tabmanView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageView.makeRound()
    }
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(userStackView)
        userStackView.addArrangedSubview(profileNameLabel)
        userStackView.addArrangedSubview(emailLabel)
        addSubview(menuTableView)
        addSubview(tabmanView)
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(8)
            $0.size.equalTo(100)
        }
        
        userStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(8)
        }
        
        menuTableView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(180)
        }
        
        tabmanView.snp.makeConstraints {
            $0.top.equalTo(menuTableView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func configureData(_ data: User) {
        profileNameLabel.text = data.nick
        emailLabel.text = data.email
        if let profileImage = data.profileImage {
            APIManager.shared.requestImageData(image: profileImage) { [weak self] data in
                self?.profileImageView.image = UIImage(data: data)
            }
        }
    }
}


