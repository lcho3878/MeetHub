//
//  PostingCollectionViewCell.swift
//  MeetHub
//
//  Created by 이찬호 on 8/22/24.
//

import UIKit
import SnapKit

final class PostingCollectionViewCell: UICollectionViewCell {
    
    let mainImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(mainImageView)
        
        mainImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
