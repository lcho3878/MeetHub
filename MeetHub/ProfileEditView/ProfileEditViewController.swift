//
//  ProfileEditViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import UIKit
import RxSwift
import RxGesture
import PhotosUI

final class ProfileEditViewController: BaseViewController {
    
    var user: User?
    
    private let profileEditView = ProfileEditView()
    
    private let viewModel = ProfileEditViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let imageDataInput = BehaviorSubject<Data?>(value: nil)
    
    override func loadView() {
        view = profileEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {

        
        let input = ProfileEditViewModel.Input(
            nicknameInput: profileEditView.nicknameTextField.rx.text.orEmpty,
            imageDataInput: imageDataInput,
            editButtonTap: profileEditView.editButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.userOutput
            .bind(with: self) { owner, user in
                owner.profileEditView.configureData(user)
            }
            .disposed(by: disposeBag)

        profileEditView.profileImageView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self, onNext: { owner, _ in
                owner.openGallery()
            })
            .disposed(by: disposeBag)
    
    }
    
}

extension ProfileEditViewController: PHPickerViewControllerDelegate {
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for (index, result) in results.enumerated() {
            guard index < 1 else { break }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        guard let data = image.pngData() else { return }
                        self?.imageDataInput.onNext(data)
                    }
                }
            }
        }
    }
}
