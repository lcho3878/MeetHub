//
//  SignupViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignupViewController: BaseViewController {
    
    private let signupView = SignupView()
    
    override func loadView() {
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        
    }
}
