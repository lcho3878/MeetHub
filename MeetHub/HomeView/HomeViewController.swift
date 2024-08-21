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
    
    private let homeView = HomeView()
    
    private let viewModel = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input: input)

        output.postOutput
            .bind(to: homeView.tableView.rx.items(cellIdentifier: HomeTableViewCell.id, cellType: HomeTableViewCell.self)) { (row, element, cell) in
                cell.configureDate(element)
            }
            .disposed(by: disposeBag)
        
        output.errorOutput
            .bind(with: self) { owner, error in
                owner.showAlert(content: error.localizedDescription) {
                    owner.changeToLoginViewController()
                }
            }
            .disposed(by: disposeBag)
    }
    
}
