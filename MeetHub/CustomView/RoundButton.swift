//
//  RoundButton.swift
//  MeetHub
//
//  Created by 이찬호 on 8/17/24.
//

import UIKit

class RoundButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .systemBlue : .lightGray
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
//        let button = UIButton(type: .system)
        setTitle(title, for: .normal)
        backgroundColor = .systemBlue
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
