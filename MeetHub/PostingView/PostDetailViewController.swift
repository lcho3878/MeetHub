//
//  PostDetailViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import UIKit
import RxSwift

final class PostDetailViewController: BaseViewController {
    
    var postID: String?
    
    private let postDetailView = PostDetailView()
    
    private let viewModel = PostDetailViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = postDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        guard let postID else { return }
        
        let input = PostDetailViewModel.Input(postIDInput: Observable.just(postID))
        let output = viewModel.transform(input: input)
        
        output.postOutput
            .bind(with: self) { owner, post in
                owner.postDetailView.configureData(post)
            }
            .disposed(by: disposeBag)
        
        output.imageDataOutput
            .bind(to: postDetailView.collectionView.rx.items(cellIdentifier: PostDetailViewCell.id, cellType: PostDetailViewCell.self)) { row, element, cell in
                cell.mainImageView.image = UIImage(data: element)
            }
            .disposed(by: disposeBag)
    }
}
