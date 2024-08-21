//
//  HomeCollectionViewCell.swift
//  MeetHub
//
//  Created by 이찬호 on 8/21/24.
//

import UIKit
import SnapKit

final class HomeCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            buttonLabel.backgroundColor = isSelected ? .lightGray : .white
            buttonLabel.textColor = isSelected ? .white : .black
        }
    }
    
    private let buttonLabel = {
        let view = UILabel()
        view.text = "테스트"
        view.textAlignment = .center
        view.layer.borderWidth = 0.2
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(buttonLabel)
        
        buttonLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureData(_ data: String) {
        buttonLabel.text = data
    }
    
}
