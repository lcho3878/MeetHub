//
//  HomeTableViewCell.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import UIKit
import SnapKit

final class HomeTableViewCell: UITableViewCell {
    static let id = "HomeTableViewCell"
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스ㅡㅌ"
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "컨텐츠"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        
        mainImageView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview().inset(8)
            $0.width.equalTo(mainImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(titleLabel)
        }
    }
    
    func configureDate(_ data: Post) {
        titleLabel.text = data.title
        contentLabel.text = data.content
    }
}
