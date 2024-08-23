//
//  PostDetailView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import UIKit
import SnapKit
import NMapsMap

final class PostDetailView: BaseView {
    
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
    
    let addButton = {
        let view = UIButton()
        view.setTitle("갤러리에서 추가하기", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        view.backgroundColor = .white
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
        addSubview(addButton)
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
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(addButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(400)
        }

    }
    
    func configureData(_ data: Post) {
        titleTextField.text = data.title
        contentTextField.text = data.content
        if let coord = data.content1?.asCoord() {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: coord.lat, lng: coord.lon)
            marker.mapView = mapView.mapView
        }
    }
}
