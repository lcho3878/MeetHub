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
//import RxGesture
import PhotosUI

protocol MarkerUpdateDelegate: AnyObject {
    func updateMarker(_ coord: Coord?)
}

final class PostingViewController: BaseViewController {
    
    weak var delegate: HomeViewControllerDelegate?
        
    let markerInput = BehaviorSubject<Coord?>(value: nil)
    
    lazy var uploadButton = UIBarButtonItem(title: "업로드", style: .plain, target: self, action: nil)
    
    private let postingView = PostingView()
    
    private let viewModel = PostingViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let dataInput = PublishSubject<Data>()
 
    
    override func loadView() {
        view = postingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PostingVC Load")
        CLLocationManager().requestWhenInUseAuthorization()
//        postingView.mapView.mapView.touchDelegate = self
        navigationItem.rightBarButtonItem = uploadButton
        bind()
    }
    
    private func bind() {
        let deleteTap = PublishSubject<Int>()
        
        let input = PostingViewModel.Input(
            titleInput: postingView.titleTextField.rx.text.orEmpty,
            contentInput: postingView.contentTextView.rx.text.orEmpty,
            markerInput: markerInput,
            dataInput: dataInput, deleteTap: deleteTap,
            uploadButtonTap: uploadButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.datasOutput
            .bind(to: postingView.collectionView.rx.items(cellIdentifier: PostingCollectionViewCell.id, cellType: PostingCollectionViewCell.self)) { row, element, cell in
                let total = try? output.datasOutput.value().count
                if row == 0 {
                    cell.updateDataCount(total)
                }
                cell.configureData(element)
                cell.deleteButton.rx.tap
                    .map { row }
                    .bind(to: deleteTap)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.successOutput
            .bind(with: self) { owner, _ in
                owner.delegate?.reloadRequest()
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        postingView.collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                guard indexPath.item == 0 else { return }
                owner.openGallery()
            }
            .disposed(by: disposeBag)
        
        postingView.mapButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                let mapVC = MapviewController()
                mapVC.viewType = .other
                mapVC.delegate = owner
                mapVC.coord = try? owner.markerInput.value()
                owner.navigationController?.pushViewController(mapVC, animated: true)
            })
            .disposed(by: disposeBag)
    
    }

}

extension PostingViewController: PHPickerViewControllerDelegate {
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

extension PostingViewController: MarkerUpdateDelegate {
    func updateMarker(_ coord: Coord?) {
        markerInput.onNext(coord)
        if let coord {
            postingView.mapButton.rx.title()
                .onNext("지도 수정하기")
        }
    }
    
    
}

//extension PostingViewController: NMFMapViewTouchDelegate {
//    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        if let preMarker {
//            preMarker.mapView = nil
//        }
//        let marker = NMFMarker()
//        preMarker = marker
//        marker.position = NMGLatLng(lat: latlng.lat, lng: latlng.lng)
//        let coord = Coord(lat: latlng.lat, lon: latlng.lng)
//        markerInput.onNext(coord)
//        marker.mapView = mapView
//    }
//}

struct Coord {
    let lat: Double
    let lon: Double
    
    func asString() -> String {
        return "[\(self.lat), \(self.lon)]"
    }
}
