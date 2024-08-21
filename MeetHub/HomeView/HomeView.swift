//
//  HomeView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import UIKit
import SnapKit

final class HomeView: BaseView {
    
    let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 50)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.id)
        return view
    }()
    
    let tableView = {
        let view = UITableView()
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        view.rowHeight = 120
        return view
    }()
    
    let postingButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 25
        return view
    }()
    
    override func setupViews() {
        addSubview(collectionView)
        addSubview(tableView)
        addSubview(postingButton)
        
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        postingButton.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
