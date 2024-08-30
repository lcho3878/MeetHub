//
//  MyPostViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/30/24.
//

import UIKit
import RxSwift

final class MyPostViewController: UIViewController {
    
    private let myPostView = MyPostView()
    
    private let viewModel = MyPostViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = myPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let requestInput = PublishSubject<Void>()
        let input = MyPostViewModel.Input(requestInput: requestInput)
        let output = viewModel.transform(input: input)
        
        output.postOutput
            .bind(to: myPostView.tableView.rx.items(cellIdentifier: HomeTableViewCell.id, cellType: HomeTableViewCell.self)) {
                row, element, cell in
                cell.configureDate(element)
            }
            .disposed(by: disposeBag)
        
        myPostView.tableView.rx.modelSelected(Post.self)
            .bind(with: self) { owner, post in
                let detailVC = PostDetailViewController()
                detailVC.postID = post.post_id
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        requestInput.onNext(())

    }
}
