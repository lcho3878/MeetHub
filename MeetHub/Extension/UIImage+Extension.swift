//
//  UIImage+Extension.swift
//  MeetHub
//
//  Created by 이찬호 on 8/30/24.
//

import UIKit

extension UIImage {
    func asMint() -> UIImage {
        return self.withTintColor(AppColor.mint, renderingMode: .alwaysOriginal)
    }
}
