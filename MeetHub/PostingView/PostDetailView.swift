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
    
    private let height: CGFloat = 250
    
    private var preMarker: NMFMarker?
    
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
    
     let creatorProfileImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    
     let creatorStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
    
    let titleTextField = {
        let view = UITextField()
        view.placeholder = "제목을 입력해주세요."
        view.isEnabled = false
        return view
    }()
    
    let contentTextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.isEditable = false
        view.isSelectable = false
        view.isScrollEnabled = false
        return view
    }()
    
    lazy var collectionView = {
        let size = CGSize(width: UIScreen.main.bounds.width, height: height)
        let layout = UICollectionView.appCollectionViewLayoutWithNoInset(size: size)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PostDetailViewCell.self, forCellWithReuseIdentifier: PostDetailViewCell.id)
        view.isPagingEnabled = true
        view.backgroundColor = .clear
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
        creatorProfileImageView.makeRound()
    }
    
    override func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(creatorProfileImageView)
        contentView.addSubview(creatorStackView)
        creatorStackView.addArrangedSubview(creatorNameLabel)
        creatorStackView.addArrangedSubview(createAtLabel)
        contentView.addSubview(contentTextView)
        contentView.addSubview(collectionView)
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
        
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView)
            $0.height.lessThanOrEqualTo(height)
        }
        
        creatorProfileImageView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.leading.equalTo(contentView).offset(8)
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

        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(titleTextField)
            $0.height.greaterThanOrEqualTo(40)
        }
        
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(200)
            $0.bottom.equalTo(contentView).inset(100)
        }

    }
    
    func configureData(_ data: Post) {
        titleTextField.text = data.title
        contentTextView.text = data.content
        creatorNameLabel.text = data.creator.nick
        if let preMarker {
            preMarker.mapView = nil
        }
        if let coord = data.content1?.asCoord() {
            let marker = NMFMarker()
            let position = NMGLatLng(lat: coord.lat, lng: coord.lon)
            marker.position = position
            marker.mapView = mapView.mapView
            preMarker = marker
            let cameraUpdate = NMFCameraUpdate(scrollTo: position)
            mapView.mapView.moveCamera(cameraUpdate)
        }
        if let profileImage = data.creator.profileImage {
            APIManager.shared.requestImageData(image: profileImage) { [weak self] data in
                self?.creatorProfileImageView.image = UIImage(data: data)
            }
        }
        
        collectionView.isHidden = data.files.isEmpty
    }
}
