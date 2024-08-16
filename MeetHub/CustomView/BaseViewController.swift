//
//  BaseViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/16/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(content: String?) {
        let alert = UIAlertController(title: nil, message: content, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
