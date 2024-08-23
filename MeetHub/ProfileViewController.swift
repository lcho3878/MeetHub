//
//  ProfileViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    private let profileView = ProfileView()
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("profileVC load")
    }
}
