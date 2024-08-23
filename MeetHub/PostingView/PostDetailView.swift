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
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let creatorNameLabel = {
        let view = UILabel()
        view.text = "닉네임 들어갈거"
        return view
    }()
    
    private let createAtLabel = {
        let view = UILabel()
        view.text = "2020년 12월 24일 게시됨"
        return view
    }()
    
    private let creatorProfileImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let creatorStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .vertical
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
        view.register(PostDetailViewCell.self, forCellWithReuseIdentifier: PostDetailViewCell.id)
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        creatorProfileImageView.layer.cornerRadius = creatorProfileImageView.frame.width / 2
    }
    
    override func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(creatorProfileImageView)
        contentView.addSubview(creatorStackView)
        creatorStackView.addArrangedSubview(creatorNameLabel)
        creatorStackView.addArrangedSubview(createAtLabel)
        contentView.addSubview(contentTextField)
        contentView.addSubview(collectionView)
        contentView.addSubview(addButton)
        contentView.addSubview(mapView)
        

        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        creatorProfileImageView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.leading.equalTo(titleTextField).offset(8)
            $0.size.equalTo(50)
        }
        
        creatorStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(creatorProfileImageView)
            $0.leading.equalTo(creatorProfileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(creatorStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(contentView)
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
            $0.bottom.equalTo(contentView).inset(100)
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
        if let profileImage = data.creator.profileImage {
            APIManager.shared.requestImageData(image: profileImage) { [weak self] data in
                self?.creatorProfileImageView.image = UIImage(data: data)
            }
        }
    }
}
