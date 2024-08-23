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
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("profileVC load")
        profileView.myprofileButton.addTarget(self, action: #selector(click), for: .touchUpInside)
        profileView.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc func click() {
        let a = APIManager.shared.callRequest(api: .myProfile, type: User.self)
        a.asObservable()
            .bind { [weak self] user in
                dump(user)
                self?.profileView.configureData(user)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func logout() {
        UserDefaultsManager.shared.token = ""
        UserDefaultsManager.shared.refreshToken = ""
        changeToLoginViewController()
    }
}
