//
//  NetworkErrorView.swift
//  MeetHub
//
//  Created by 이찬호 on 9/6/24.
//

import UIKit
import SnapKit

final class NetworkErrorView: BaseView {
    private let errorLabel = {
        let view = UILabel()
        view.text = "네트워크 오류류류류"
        view.font = .systemFont(ofSize: 30)
        return view
    }()
    
    override func setupViews() {
        addSubview(errorLabel)
        
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
