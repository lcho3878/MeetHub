//
//  ProfileViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import UIKit
import RxSwift

final class ProfileViewController: BaseViewController {
    
    private let profileView = ProfileView()
    
    private let viewModel = ProfileViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {

        let menuInput = PublishSubject<ProfileViewModel.ProfileMenu>()
        
        let input = ProfileViewModel.Input(menuInput: menuInput)
        let output = viewModel.transform(input: input)

        profileView.menuTableView.rx.modelSelected(ProfileViewModel.ProfileMenu.self)
            .bind { menu in
                menuInput.onNext(menu)
            }
            .disposed(by: disposeBag)
        
        output.menuOutput
            .bind(to: profileView.menuTableView.rx.items(cellIdentifier: ProfileTableViewCell.id, cellType: ProfileTableViewCell.self)) { row, element, cell in
                cell.configureData(element)
            }
            .disposed(by: disposeBag)
        
        output.inquiryOutput
            .bind(with: self) { owner, user in
                owner.profileView.configureData(user)
            }
            .disposed(by: disposeBag)
        
        output.editOutput
            .bind(with: self) { owner, _ in
                print("프로필 수정 view 로직")
            }
            .disposed(by: disposeBag)
        
        output.logoutOutput
            .bind(with: self) { owner, _ in
                UserDefaultsManager.shared.logout()
                owner.changeToLoginViewController()
            }
            .disposed(by: disposeBag)
    }
}
