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
import RxRelay

final class PostEditViewController: BaseViewController {
    
    weak var delegate: PostDetailViewControllerDelegate?
    
    var preMarker: NMFMarker?
    
    var postID: String?
    
    let markerInput = BehaviorSubject<Coord?>(value: nil)
    
    private let postEditView = PostEditView()
    
    private let viewModel = PostEditViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let dataInput = PublishSubject<Data>()
    
    let titleInput = PublishSubject<String>()
    
    private lazy var modifyButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: nil)
    
    override func loadView() {
        view = postEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CLLocationManager().requestWhenInUseAuthorization()
        navigationItem.rightBarButtonItem = modifyButton
        bind()
    }
    
    private func bind() {
        guard let postID else { return }
        let deleteTap = PublishSubject<Int>()
        
        let input = PostEditViewModel.Input(
            postIDInput: Observable.just(postID),
            titleInput: postEditView.titleTextField.rx.text.orEmpty,
            contentInput: postEditView.contentTextView.rx.text.orEmpty,
            markerInput: markerInput,
            dataInput: dataInput,
            deleteTap: deleteTap,
            modifyButtonTap: modifyButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.imageDataOutput
            .bind(to: postEditView.collectionView.rx.items(cellIdentifier: PostingCollectionViewCell.id, cellType: PostingCollectionViewCell.self)) { row, element, cell in
                let total = try? output.imageDataOutput.value().count
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
        
        output.postOutput
            .bind(with: self) { owner, post in
                owner.postEditView.configureData(post)
                owner.postEditView.titleTextField.sendActions(for: .editingChanged)
                owner.modifyButton.rx.isHidden.onNext(!post.isMyPost)
                owner.markerInput.onNext(post.content1?.asCoord())
            }
            .disposed(by: disposeBag)
        
        output.successOutput
            .bind(with: self) { owner, _ in
                owner.delegate?.reloadRequest()
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.fileErrorOutput
            .bind(with: self) { owner, error in
                owner.showAlert(content: error?.errorMessage)
            }
            .disposed(by: disposeBag)
        
        output.postErrorOutput
            .bind(with: self) { owner, error in
                owner.showAlert(content: error?.errorMessage)
            }
            .disposed(by: disposeBag)
        
        postEditView.collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                guard indexPath.item == 0 else { return }
                owner.openGallery()
            }
            .disposed(by: disposeBag)
        
        postEditView.mapButton.rx.tap
            .bind(with: self) { owner, _ in
                let mapVC = MapviewController()
                mapVC.viewType = .other
                mapVC.delegate = owner
                mapVC.coord = try? owner.markerInput.value()
                owner.navigationController?.pushViewController(mapVC, animated: true)
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

extension PostEditViewController: MarkerUpdateDelegate {
    func updateMarker(_ coord: Coord?) {
        markerInput.onNext(coord)
//        if let coord {
//            postEditView.mapButton.rx.title()
//                .onNext("지도 업데이트 완료")
//        }
    }
    
    
}
