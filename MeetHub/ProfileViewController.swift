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
    
    private let requestInput = PublishSubject<Void>()
    
    override func loadView() {
        view = profileView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let menuInput = PublishSubject<ProfileViewModel.ProfileMenu>()
        
        let input = ProfileViewModel.Input(menuInput: menuInput, requestInput: requestInput)
        let output = viewModel.transform(input: input)
        
        requestInput.onNext(())

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
                let profileEditVC = ProfileEditViewController()
                profileEditVC.delegate = owner
                owner.navigationController?.pushViewController(profileEditVC, animated: true)
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

extension ProfileViewController: ProfileEditViewControllerDelegate {
    func reloadRequest() {
        requestInput.onNext(())
    }
}
