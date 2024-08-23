//
//  HomeTableViewCell.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import UIKit
import SnapKit
import RxSwift

final class HomeTableViewCell: UITableViewCell {
    
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
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "컨텐츠"
        label.textColor = .lightGray
        return label
    }()
    
    let content1Label :UILabel = {
        let view = UILabel()
        view.text = "컨텐츠1"
        view.textColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
    
    private func setupViews() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(content1Label)
        
        mainImageView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview().inset(8)
            $0.width.equalTo(mainImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        content1Label.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
    }

    func configureDate(_ data: Post) {
        titleLabel.text = data.title
        dateLabel.text = data.createdAt
        content1Label.text = data.content1
        if let first = data.files.first {
            APIManager.shared.requestImageData(image: first) { [weak self] data in
                self?.mainImageView.image = UIImage(data: data)
            }
        }
    }
}
