//
//  ProfileTableViewCell.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import UIKit
import SnapKit

final class ProfileTableViewCell: UITableViewCell {
    
    private let titleLabel = {
        let view = UILabel()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureData(_ data: ProfileViewModel.ProfileMenu) {
        titleLabel.text = data.title
    }
}
