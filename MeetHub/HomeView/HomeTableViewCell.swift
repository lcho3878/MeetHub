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
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    let content1Label :UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    let bottomStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    let tagLabel = {
        let view = UILabel()
        view.textColor = .systemBlue
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    let likesImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        return view
    }()
    
    let likesLabel = {
        let view = UILabel()
        return view
    }()
    
    let recommendImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "hand.thumbsup.fill")?.withTintColor(AppColor.mint, renderingMode: .alwaysOriginal)
        return view
    }()
    
    let recommendLabel = {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }
    
    private func setupViews() {
        contentView.backgroundColor = AppColor.beige
        
        contentView.addSubview(mainImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(content1Label)
        contentView.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(tagLabel)
        bottomStackView.addArrangedSubview(likesImageView)
        bottomStackView.addArrangedSubview(likesLabel)
        bottomStackView.addArrangedSubview(recommendImageView)
        bottomStackView.addArrangedSubview(recommendLabel)
        
        mainImageView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview().inset(8)
            $0.width.equalTo(mainImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(titleLabel)
        }
        
        content1Label.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(titleLabel)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(content1Label.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        tagLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(likesImageView.snp.leading)
        }
        
        recommendLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.width.greaterThanOrEqualTo(20)
        }
        
        recommendImageView.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.trailing.equalTo(recommendLabel.snp.leading)
        }
        
        likesLabel.snp.makeConstraints {
            $0.trailing.equalTo(recommendImageView.snp.leading)
            $0.width.greaterThanOrEqualTo(20)
        }
        
        likesImageView.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.trailing.equalTo(likesLabel.snp.leading)
        }
    
    }

    func configureDate(_ data: Post) {
        titleLabel.text = data.title
        dateLabel.text = data.dateLabelText
        content1Label.text = data.content
        if let first = data.files.first {
            APIManager.shared.requestImageData(image: first) { [weak self] data in
                self?.mainImageView.image = UIImage(data: data)
            }
        }
        tagLabel.text = data.hashTags.map{ "#" + $0 }.joined(separator: ", ")
        likesLabel.text = "\(data.likes.count)"
        recommendLabel.text = "\(data.likes2.count) "
    }
}
