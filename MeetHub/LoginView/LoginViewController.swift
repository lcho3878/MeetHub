//
//  LoginViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/14/24.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    private let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

