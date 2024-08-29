//
//  TextView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/26/24.
//

import UIKit

final class TextView: UITextView {
    
    init(placeholder: String?) {
        super.init(frame: .zero, textContainer: .none)
        text = placeholder
        textColor = .lightGray
        backgroundColor = .clear
        layer.cornerRadius = 4
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.lightGray.cgColor
        font = .systemFont(ofSize: 17)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

