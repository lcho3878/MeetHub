//
//  PostDetailViewCell.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//
import UIKit
import SnapKit
import RxSwift

final class PostDetailViewCell: UICollectionViewCell {
    
    let mainImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let fakeView = {
        let view = UIView()
        view.backgroundColor = AppColor.beige
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
        mainImageView.addSubview(fakeView)
        
        mainImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        fakeView.snp.makeConstraints {
            $0.height.equalTo(8)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        
    }
}
