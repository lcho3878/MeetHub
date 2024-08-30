//
//  MyPostView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/30/24.
//

import UIKit
import SnapKit

final class MyPostView: BaseView {

    
    let tableView = UITableView.postTableView()
    
    override func setupViews() {
        addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
        }
    }
    
}
