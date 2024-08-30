//
//  PostingView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/22/24.
//

import UIKit
import SnapKit

final class PostingView: UsingTextView {
    
    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    let titleTextField = RoundTextField(placeholder: "* 제목을 입력해주세요")
    
    lazy var contentTextView = {
        placeholder = "* 내용을 입력해주세요. \n원하는 단어 앞에 #을 붙이면 해시태그를 사용할 수 있습니다. \nex) #데이트, #맛집 ..."
        let view = TextView(placeholder: placeholder)
        view.delegate = self
        return view
    }()
    
    let collectionView = {
        let size = CGSize(width: 100, height: 100)
        let layout = UICollectionView.appCollectionViewLayout(size: size)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PostingCollectionViewCell.self, forCellWithReuseIdentifier: PostingCollectionViewCell.id)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var mapButton = {
        let view = RoundButton(title: "지도 추가하기")
        view.backgroundColor = .clear
        view.setTitleColor(AppColor.mint, for: .normal)
        view.layer.borderColor = AppColor.sage.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    override func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(contentTextView)
        contentView.addSubview(collectionView)
        contentView.addSubview(mapButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.horizontalEdges.equalTo(contentView).inset(24)
            $0.height.equalTo(44)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(titleTextField)
            $0.height.equalTo(300)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        
        mapButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(50)
            $0.bottom.equalTo(contentView).inset(100)
        }

    }
}

//extension PostingView: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = .black
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "내용 입력"
//            textView.textColor = .lightGray
//        }
//    }
//}



