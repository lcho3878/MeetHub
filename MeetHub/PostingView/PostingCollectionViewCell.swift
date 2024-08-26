//
//  PostingCollectionViewCell.swift
//  MeetHub
//
//  Created by 이찬호 on 8/22/24.
//

import UIKit
import SnapKit
import RxSwift

final class PostingCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let mainImageView = {
        let view = UIImageView()
//        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.sage.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let addImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "camera.fill")?.withTintColor(AppColor.mint, renderingMode: .alwaysOriginal)
        return view
    }()
    
    let deleteButton = {
        let view = UIButton()
        let image = UIImage(systemName: "xmark.circle")?.withTintColor(AppColor.orange, renderingMode: .alwaysOriginal)
        view.setImage(image, for: .normal)
        view.backgroundColor = .white
        return view
    }()
    
    private let totalLabel = {
        let view = UILabel()
        view.text = "1/5"
        view.font = .boldSystemFont(ofSize: 16)
        view.textAlignment = .center
        view.textColor = AppColor.sage
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        deleteButton.makeRound()
    }
    
    private func setupViews() {
        contentView.addSubview(mainImageView)
        contentView.addSubview(addImageView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(totalLabel)
        
        mainImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.center.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalTo(mainImageView).inset(8)
            $0.size.equalTo(20)
        }
        
        totalLabel.snp.makeConstraints {
            $0.top.equalTo(addImageView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
    }
    
    func configureData(_ data: Data) {
        totalLabel.isHidden = !data.isEmpty
        deleteButton.isHidden = data == Data()
        mainImageView.backgroundColor = data == Data() ? AppColor.beige : .clear
        addImageView.isHidden = data != Data()
        mainImageView.image = UIImage(data: data)
    }
    
    func updateDataCount(_ total: Int?) {
        guard let total else { return }
        totalLabel.text = "\(total - 1)/5"
    }
}
