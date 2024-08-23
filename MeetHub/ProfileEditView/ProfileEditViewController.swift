//
//  ProfileEditViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import UIKit
import RxSwift

final class ProfileEditViewController: BaseViewController {
    
    var user: User?
    
    private let profileEditView = ProfileEditView()
    
    private let viewModel = ProfileEditViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = profileEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let imageDataInput = PublishSubject<Data?>()
        
        let input = ProfileEditViewModel.Input(
            nicknameInput: profileEditView.nicknameTextField.rx.text.orEmpty,
            imageDataInput: imageDataInput,
            editButtonTap: profileEditView.editButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.userOutput
            .bind(with: self) { owner, user in
                owner.profileEditView.configureData(user)
                imageDataInput.onNext(owner.profileEditView.profileImageView.image?.pngData())
            }
            .disposed(by: disposeBag)


    
    }
    
}
