//
//  UICollectionView+Extension.swift
//  MeetHub
//
//  Created by 이찬호 on 8/26/24.
//

import UIKit

extension UICollectionView {
    static func appCollectionViewLayout(size: CGSize) -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.itemSize = CGSize(width: size.width, height: size.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return layout
    }
    
    static func appCollectionViewLayoutWithNoInset(size: CGSize) -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: size.width, height: size.height)
        return layout
    }
    
}
