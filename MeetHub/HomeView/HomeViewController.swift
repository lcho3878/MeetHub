//
//  HomeViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    
    let tests = [
        Post(post_id: "", product_id: "", title: "테스트1", content: "테스트컨텐츠", content1: "", content2: "", content3: "", content4: "", content5: "", createdAt: ""),
        Post(post_id: "", product_id: "", title: "테스트2", content: "테스트컨4141텐츠", content1: "", content2: "", content3: "", content4: "", content5: "", createdAt: ""),
        Post(post_id: "", product_id: "", title: "테스트3", content: "테스트123컨텐츠", content1: "", content2: "", content3: "", content4: "", content5: "", createdAt: "")
    ]
    
    private let homeView = HomeView()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        homeView.tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.id)
        homeView.tableView.rowHeight = 120
        
        Observable.just(tests)
            .bind(to: homeView.tableView.rx.items(cellIdentifier: HomeTableViewCell.id, cellType: HomeTableViewCell.self)) { (row, element, cell) in
                cell.configureDate(element)
            }
            .disposed(by: disposeBag)
    }
    
}
