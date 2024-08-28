//
//  SearchView.swift
//  MeetHub
//
//  Created by 이찬호 on 8/29/24.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    
    let searchTextField = {
        let view = UITextField()
        view.placeholder = "장소 검색해보세요"
        return view
    }()
    
    let searchTableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.id)
        view.rowHeight = 120
        view.isHidden = true
        return view
    }()
    
    override func setupViews() {
        addSubview(searchTextField)
        addSubview(searchTableView)
        
        searchTextField.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self).inset(24)
            $0.height.equalTo(44)
        }
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
