//
//  PostingViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/21/24.
//

import UIKit
import CoreLocation
import NMapsMap
import RxSwift
import RxCocoa
import PhotosUI

final class PostingViewController: BaseViewController {
    
    var preMarker: NMFMarker?
    
    let markerInput = PublishSubject<Coord>()
    
    private let postingView = PostingView()
    
    private let viewModel = PostingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = postingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PostingVC Load")
        postingView.collectionView.delegate = self
        postingView.collectionView.dataSource = self
        CLLocationManager().requestWhenInUseAuthorization()
        postingView.mapView.mapView.touchDelegate = self
        bind()
    }
    
    private func bind() {
        let input = PostingViewModel.Input(markerInput: markerInput)
        let output = viewModel.transform(input: input)

    }
    
    var images = [Data]()
}

extension PostingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostingCollectionViewCell.id, for: indexPath) as? PostingCollectionViewCell else { return UICollectionViewCell() }
        cell.mainImageView.image = UIImage(data: images[indexPath.item])
        return cell
    }

    
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension PostingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for (index, result) in results.enumerated() {
            guard index < 5 else { break }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        guard let data = image.pngData() else { return }
                        self?.images.append(data)
                        self?.postingView.collectionView.reloadData()
                    }
                }
            }
        }
    }
}

extension PostingViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        openGallery()
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

struct Coord {
    let lat: Double
    let lon: Double
}
