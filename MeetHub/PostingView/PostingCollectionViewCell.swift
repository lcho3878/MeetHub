//
//  PostingCollectionViewCell.swift
//  MeetHub
//
//  Created by 이찬호 on 8/22/24.
//

import UIKit
import SnapKit
import RxSwift

final class PostingCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let mainImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let deleteButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setupViews() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(deleteButton)
        
        mainImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalTo(mainImageView).inset(8)
            $0.size.equalTo(20)
        }
    }
}
