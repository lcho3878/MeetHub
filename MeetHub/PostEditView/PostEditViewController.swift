//
//  PostEditViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import UIKit
import RxSwift
import PhotosUI
import NMapsMap

final class PostEditViewController: BaseViewController {
    
    var preMarker: NMFMarker?
    
    var postID: String?
    
    let markerInput = BehaviorSubject<Coord?>(value: nil)
    
    private let postEditView = PostEditView()
    
    private let viewModel = PostEditViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let dataInput = PublishSubject<Data>()
    
    private lazy var modifyButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: nil)
    
    override func loadView() {
        view = postEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CLLocationManager().requestWhenInUseAuthorization()
        postEditView.mapView.mapView.touchDelegate = self
        navigationItem.rightBarButtonItem = modifyButton
        bind()
    }
    
    private func bind() {
        guard let postID else { return }
        let deleteTap = PublishSubject<Int>()
        
        let input = PostEditViewModel.Input(
            postIDInput: Observable.just(postID),
            titleInput: postEditView.titleTextField.rx.text.orEmpty,
            contentInput: postEditView.contentTextField.rx.text.orEmpty,
            markerInput: markerInput,
            dataInput: dataInput, 
            deleteTap: deleteTap,
            modifyButtonTap: modifyButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.imageDataOutput
            .bind(to: postEditView.collectionView.rx.items(cellIdentifier: PostingCollectionViewCell.id, cellType: PostingCollectionViewCell.self)) { row, element, cell in
                cell.mainImageView.image = UIImage(data: element)
                cell.deleteButton.rx.tap
                    .map { row }
                    .bind(to: deleteTap)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.postOutput
            .bind(with: self) { owner, post in
                owner.postEditView.configureData(post)
                owner.modifyButton.rx.isHidden.onNext(!post.isMyPost)
                if let coord = post.content1?.asCoord() {
                    let marker = NMFMarker()
                    let position = NMGLatLng(lat: coord.lat, lng: coord.lon)
                    marker.position = position
                    marker.mapView = owner.postEditView.mapView.mapView
                    owner.preMarker = marker
                    let cameraUpdate = NMFCameraUpdate(scrollTo: position)
                    owner.postEditView.mapView.mapView.moveCamera(cameraUpdate)
                }
            }
            .disposed(by: disposeBag)
        
//        output.imageDataOutput
//            .bind(to: postEditView.collectionView.rx.items(cellIdentifier: PostDetailViewCell.id, cellType: PostDetailViewCell.self)) { row, element, cell in
//                cell.mainImageView.image = UIImage(data: element)
//            }
//            .disposed(by: disposeBag)
        
        postEditView.addButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.openGallery()
            }
            .disposed(by: disposeBag)
    }
}

extension PostEditViewController: PHPickerViewControllerDelegate {
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for (index, result) in results.enumerated() {
            guard index < 5 else { break }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        guard let data = image.pngData() else { return }
                        self?.dataInput.onNext(data)
                    }
                }
            }
        }
    }
}

extension PostEditViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        if let preMarker {
            preMarker.mapView = nil
        }
        let marker = NMFMarker()
        preMarker = marker
        marker.position = NMGLatLng(lat: latlng.lat, lng: latlng.lng)
        let coord = Coord(lat: latlng.lat, lon: latlng.lng)
        markerInput.onNext(coord)
        marker.mapView = mapView
    }
}
