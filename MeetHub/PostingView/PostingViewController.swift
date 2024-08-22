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
}

extension PostingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostingCollectionViewCell.id, for: indexPath) as? PostingCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

extension PostingViewController: NMFMapViewTouchDelegate {
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

struct Coord {
    let lat: Double
    let lon: Double
}
