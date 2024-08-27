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
    
    private lazy var rightBarButton = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(rightBarButtonTap))
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewType, viewType == .other {
            mapView.mapView.touchDelegate = self
        }
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        configureMapView(coord)
        navigationItem.rightBarButtonItem = rightBarButton
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
            let marker = NMFMarker()
            let position = NMGLatLng(lat: coord.lat, lng: coord.lon)
            marker.position = position
            marker.mapView = mapView.mapView
            preMarker = marker
            let cameraUpdate = NMFCameraUpdate(scrollTo: position)
            mapView.mapView.moveCamera(cameraUpdate)
        }
        else {
            
        }
    }
}
