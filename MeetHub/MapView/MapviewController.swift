//
//  MapviewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/27/24.
//

import UIKit
import SnapKit
import RxSwift
import NMapsMap

final class MapviewController: BaseViewController {
    enum ViewType {
        case detail
        case other
    }
    
    weak var delegate: MarkerUpdateDelegate?
    
    var coord: Coord?
    
    var viewType: ViewType?
    
    var preMarker: NMFMarker?
    
    let mapView = NMFNaverMapView()
    
    private lazy var searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)

    private lazy var rightBarButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(rightBarButtonTap))
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        setupMapView()
        configureMapView(coord)
        if let viewType, viewType == .other {
            mapView.mapView.touchDelegate = self
            navigationItem.rightBarButtonItems = [rightBarButton, searchButton]
        }
    }

    private func bind() {
        searchButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.openSearchViewController()
            }
            .disposed(by: disposeBag)
    }
}

extension MapviewController {
    private func setupMapView() {
        mapView.showLocationButton = true
        mapView.mapView.positionMode = .compass
    }
    
    @objc
    private func rightBarButtonTap() {
        delegate?.updateMarker(coord)
        navigationController?.popViewController(animated: true)
    }
    
    private func openSearchViewController() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        searchVC.sheetPresentationController?.detents = [.medium(), .large()]
        present(searchVC, animated: true)
    }
}

extension MapviewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        if let preMarker {
            preMarker.mapView = nil
        }
        let marker = NMFMarker()
        preMarker = marker
        let coord = Coord(lat: latlng.lat, lon: latlng.lng)
        self.coord = coord
        marker.position = NMGLatLng(lat: coord.lat, lng: coord.lon)
        marker.mapView = mapView
        
        print("수정 이벤트")
    }
    
    private func configureMapView(_ coord: Coord?) {
        if let coord {
        print("잘 넘어옴")
            let marker = NMFMarker()
            let position = NMGLatLng(lat: coord.lat, lng: coord.lon)
            marker.position = position
            marker.mapView = mapView.mapView
            preMarker = marker
            let cameraUpdate = NMFCameraUpdate(scrollTo: position)
            mapView.mapView.moveCamera(cameraUpdate)
        }
        else {
            print("없다")
//            openSearchViewController()
        }
    }
}

extension MapviewController: MarkerUpdateDelegate  {
    func updateMarker(_ coord: Coord?) {
        print("delegate 이후 coord전달")
        guard let coord else {
            print("coord없음")
            return
        }
        self.coord = coord
        if let preMarker {
            preMarker.mapView = nil
        }
        let marker = NMFMarker()
        let position = NMGLatLng(lat: coord.lat, lng: coord.lon)
        marker.position = position
        marker.mapView = mapView.mapView
        preMarker = marker
        let cameraUpdate = NMFCameraUpdate(scrollTo: position)
        mapView.mapView.moveCamera(cameraUpdate)
    }
}
