//
//  SignupView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import UIKit
import SnapKit

final class SignupView: BaseView {
    
    private let etst = UILabel()
    
    override func setupViews() {
        etst.text = "테스트"
        
        addSubview(etst)
        
        etst.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
