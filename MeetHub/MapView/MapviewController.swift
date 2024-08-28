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
    
    let mapView = {
        let view = NMFNaverMapView()
        view.showLocationButton = true
        view.mapView.positionMode = .compass
        return view
    }()
    
    private lazy var searchButton = {
        let view = UIButton()
        view.setTitle("장소 검색하기", for: .normal)
        view.setTitleColor(.black, for: .normal)
        return view
    }()

    private lazy var rightBarButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(rightBarButtonTap))
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        if let viewType, viewType == .other {
            mapView.mapView.touchDelegate = self
            view.addSubview(searchButton)
            searchButton.snp.makeConstraints {
                $0.height.equalTo(44)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            }
        }
        
        configureMapView(coord)
        navigationItem.rightBarButtonItem = rightBarButton
  
        searchButton.rx.tap
            .bind(with: self) { owner, _ in
                let searchVC = SearchViewController()
                searchVC.delegate = owner
                owner.present(searchVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }

}

extension MapviewController {
    @objc
    private func rightBarButtonTap() {
        delegate?.updateMarker(coord)
        navigationController?.popViewController(animated: true)
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
            let searchVC = SearchViewController()
            searchVC.delegate = self
            present(searchVC, animated: true)
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
