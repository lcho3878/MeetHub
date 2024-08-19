//
//  HomeView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import UIKit
import SnapKit

final class HomeView: BaseView {
    
    let tableView = UITableView()
    
    override func setupViews() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
