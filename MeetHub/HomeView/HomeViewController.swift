//
//  HomeViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/19/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeViewControllerDelegate: AnyObject {
    func reloadRequest() 
}

final class HomeViewController: BaseViewController {
    
    private let homeView = HomeView()
    
    private let viewModel = HomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    let reloadInput = PublishSubject<Void>()
    
    override func loadView() {
        view = homeView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        navigationItem.title = AppTitle.main.rawValue
        homeView.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    private func bind() {
        typealias Menu = HomeViewModel.Menu
        
        let selectedIndex = BehaviorSubject<Menu>(value: .all)
        let indexPathInput = PublishSubject<[IndexPath]>()
        
        
        let input = HomeViewModel.Input(
            menuInput: selectedIndex,
            indexPathInput: indexPathInput,
            reloadInput: reloadInput
        )
        let output = viewModel.transform(input: input)
        
        homeView.collectionView.rx.modelSelected(Menu.self)
            .bind { menu in
                selectedIndex.onNext(menu)
            }
            .disposed(by: disposeBag)
        
        homeView.tableView.rx.modelSelected(Post.self)
            .bind(with: self) { owner, post in
               let detailVC = PostDetailViewController()
                detailVC.postID = post.post_id
                detailVC.delegate = owner
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        homeView.tableView.rx.prefetchRows
            .bind(onNext: { indexPaths in
                indexPathInput.onNext(indexPaths)
            })
            .disposed(by: disposeBag)
            
        
        output.menuOutput
            .bind(to: homeView.collectionView.rx.items(cellIdentifier: HomeCollectionViewCell.id, cellType: HomeCollectionViewCell.self)) { row, element, cell in
                cell.configureData(element.menuTitle)
            }
            .disposed(by: disposeBag)
        
        output.postOutput
            .bind(to: homeView.tableView.rx.items(cellIdentifier: HomeTableViewCell.id, cellType: HomeTableViewCell.self)) { (row, element, cell) in
                cell.configureDate(element)
            }
            .disposed(by: disposeBag)
        
        output.errorOutput
            .bind(with: self) { owner, error in
                guard let error else { return }
                owner.showAlert(content: error.errorMessage) {
                    owner.changeToLoginViewController()
                }
            }
            .disposed(by: disposeBag)
        
        homeView.postingButton.rx.tap
            .bind(with: self) { owner, _ in
                let postingVC = PostingViewController()
                postingVC.delegate = owner
                owner.navigationController?.pushViewController(postingVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.scrollTopOutput
            .bind(with: self) { owner, _ in
                owner.homeView.tableView.scrollToTop()
            }
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewController: HomeViewControllerDelegate {
    func reloadRequest() {
        reloadInput.onNext(())
    }
}
