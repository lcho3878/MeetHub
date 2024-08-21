//
//  HomeView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import UIKit
import SnapKit

final class HomeView: BaseView {
    
    let tableView = {
        let view = UITableView()
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        view.rowHeight = 120
        return view
    }()
    
    override func setupViews() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
