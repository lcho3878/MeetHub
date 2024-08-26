//
//  BaseView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.beige
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
}
