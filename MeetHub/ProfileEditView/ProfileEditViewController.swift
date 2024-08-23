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
        let input = ProfileEditViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.userOutput
            .bind(with: self) { owner, user in
                owner.profileEditView.configureData(user)
            }
            .disposed(by: disposeBag)
    }
    
}
