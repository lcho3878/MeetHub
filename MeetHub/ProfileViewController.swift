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
        configureTapman()
        bind()
    }
    
    private func configureTapman() {
        let tapmanVC = ProfileTabManViewController()
        addChild(tapmanVC)
        tapmanVC.view.frame = self.profileView.tabmanView.frame
        self.profileView.tabmanView.addSubview(tapmanVC.view)
        tapmanVC.didMove(toParent: self)
    }
    
    private func bind() {
        typealias Menu = ProfileViewModel.ProfileMenu
        
        let menuInput = PublishSubject<Menu>()
        
        let input = ProfileViewModel.Input(menuInput: menuInput, requestInput: requestInput)
        let output = viewModel.transform(input: input)
        
        requestInput.onNext(())

        profileView.menuTableView.rx.modelSelected(Menu.self)
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
        
        output.menuSelectOutput
            .bind(with: self) { owner, menu in
                switch menu {
                case .profileEdit:
                    owner.openProfileEditVC()
                case .logout:
                    owner.logout()
                }
            }
            .disposed(by: disposeBag)
        
        output.errorOutput
            .bind(with: self) { owner, error in
                owner.showAlert(content: error?.errorMessage) {
                    owner.changeToLoginViewController()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController {
    private func openProfileEditVC() {
        let profileEditVC = ProfileEditViewController()
        profileEditVC.delegate = self
//        let profileEditVC = MyPostViewController()
        navigationController?.pushViewController(profileEditVC, animated: true)
    }
    
    private func logout() {
        UserDefaultsManager.shared.logout()
        changeToLoginViewController()
    }
}

extension ProfileViewController: ProfileEditViewControllerDelegate {
    func reloadRequest() {
        requestInput.onNext(())
    }
}
