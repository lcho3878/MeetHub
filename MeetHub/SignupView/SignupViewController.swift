//
//  SignupViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import UIKit

final class SignupViewController: BaseViewController {
    
    private let signupView = SignupView()
    
    override func loadView() {
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
