//
//  UsingTextView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/26/24.
//

import UIKit

class UsingTextView: BaseView, UITextViewDelegate {
    var placeholder: String?
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}
//
//extension UsingTextView: UITextViewDelegate {
//    
//}
