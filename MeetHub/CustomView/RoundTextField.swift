//
//  RoundTextField.swift
//  MeetHub
//
//  Created by 이찬호 on 8/26/24.
//

import UIKit

final class RoundTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        backgroundColor = .clear
        borderStyle = .roundedRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

