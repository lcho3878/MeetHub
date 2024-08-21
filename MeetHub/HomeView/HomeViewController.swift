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
        homeView.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    private func bind() {
        
        let selectedIndex = BehaviorSubject(value: 0)
        
        let input = HomeViewModel.Input(indexInput: selectedIndex)
        let output = viewModel.transform(input: input)
        
        homeView.collectionView.rx.itemSelected
            .bind { indexPath in
                let item = indexPath.item
                selectedIndex.onNext(item)
            }
            .disposed(by: disposeBag)
        
        output.menuOutput
            .bind(to: homeView.collectionView.rx.items(cellIdentifier: HomeCollectionViewCell.id, cellType: HomeCollectionViewCell.self)) { row, element, cell in
                cell.configureData(element)
            }
            .disposed(by: disposeBag)
        
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
