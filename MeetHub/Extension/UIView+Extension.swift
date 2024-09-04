//
//  UIView+Extension.swift
//  MeetHub
//
//  Created by 이찬호 on 8/21/24.
//

import UIKit

extension UIView {
    static var id: String {
        return String(describing: self)
    }
    
    func makeRound() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
}
