//
//  PostingView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/22/24.
//

import UIKit
import SnapKit

final class PostingView: BaseView {
    
    let titleTextField = {
        let view = UITextField()
        view.placeholder = "제목을 입력해주세요."
        return view
    }()
    
    let contentTextField = {
        let view = UITextField()
        view.placeholder = "내용을 입력해주세요"
        return view
    }()
    
    let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.itemSize = CGSize(width: 100, height: 100)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PostingCollectionViewCell.self, forCellWithReuseIdentifier: PostingCollectionViewCell.id)
        return view
    }()
    
    override func setupViews() {
        addSubview(titleTextField)
        addSubview(contentTextField)
        addSubview(collectionView)
        
        titleTextField.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        contentTextField.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(titleTextField)
            $0.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(contentTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
    }
}

