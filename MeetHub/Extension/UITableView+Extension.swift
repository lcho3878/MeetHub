//
//  UITableView+Extension.swift
//  MeetHub
//
//  Created by 이찬호 on 8/30/24.
//

import UIKit

extension UITableView {
    func scrollToTop() {
        guard self.numberOfRows(inSection: 0) > 0 else { return }
        self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    static func postTableView() -> UITableView {
        let view = UITableView()
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        view.rowHeight = 120
        view.backgroundColor = .clear
        return view
    }
}
