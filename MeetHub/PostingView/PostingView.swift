//
//  PostingView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/22/24.
//

import UIKit
import SnapKit
import NMapsMap

final class PostingView: BaseView {
    
    private let scrollView = {
        let view = UIScrollView()
        return view
    }()
    
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
    
    lazy var mapView = {
        let view = NMFNaverMapView(frame: frame)
        view.showLocationButton = true
        view.mapView.positionMode = .compass
        return view
    }()
    
    override func setupViews() {
        addSubview(titleTextField)
        addSubview(contentTextField)
        addSubview(collectionView)
        addSubview(mapView)
        
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
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(400)
        }

    }
}



