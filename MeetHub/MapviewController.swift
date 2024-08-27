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
    
    var coord: Coord?
    
    var viewType: ViewType?
    
    let mapView = NMFNaverMapView()
    
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
        
    }
}

extension MapviewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        if let preMarker {
//            preMarker.mapView = nil
//        }
//        let marker = NMFMarker()
//        preMarker = marker
//        marker.position = NMGLatLng(lat: latlng.lat, lng: latlng.lng)
//        let coord = Coord(lat: latlng.lat, lon: latlng.lng)
//        markerInput.onNext(coord)
//        marker.mapView = mapView
        
        print("수정 이벤트")
    }
    
    private func configureMapView(_ coord: Coord?) {
        if let coord {
            let marker = NMFMarker()
            let position = NMGLatLng(lat: coord.lat, lng: coord.lon)
            marker.position = position
            marker.mapView = mapView.mapView
//            preMarker = marker
            let cameraUpdate = NMFCameraUpdate(scrollTo: position)
            mapView.mapView.moveCamera(cameraUpdate)
        }
    }
}
