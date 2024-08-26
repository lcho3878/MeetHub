//
//  PostDetailViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import UIKit
import RxSwift

protocol PostDetailViewControllerDelegate: AnyObject {
    func reloadRequest()
}

final class PostDetailViewController: BaseViewController {
    
    var postID: String?
    
    weak var delegate: HomeViewControllerDelegate?
    
    private let postDetailView = PostDetailView()
    
    private let viewModel = PostDetailViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let postIDInput = PublishSubject<String>()
    
    private lazy var modifyButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: nil)
    
    private lazy var deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: nil)
    
    
    
    override func loadView() {
        view = postDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [modifyButton, deleteButton]
        bind()
    }
    
    private func bind() {
        guard let postID else { return }
        
        
        let input = PostDetailViewModel.Input(postIDInput: postIDInput)
        let output = viewModel.transform(input: input)
        postIDInput.onNext(postID)
        
        modifyButton.rx.tap
            .bind(with: self) { owner, _ in
                let editVC = PostEditViewController()
                editVC.postID = postID
                editVC.delegate = owner
                 owner.navigationController?.pushViewController(editVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind(with: self) { owner, _ in
                APIManager.shared.deletePost(postID: postID)
                owner.delegate?.reloadRequest()
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.postOutput
            .bind(with: self) { owner, post in
                owner.postDetailView.configureData(post)
                owner.modifyButton.rx.isHidden.onNext(!post.isMyPost)
                owner.deleteButton.rx.isHidden.onNext(!post.isMyPost)
            }
            .disposed(by: disposeBag)
        
        output.imageDataOutput
            .bind(to: postDetailView.collectionView.rx.items(cellIdentifier: PostDetailViewCell.id, cellType: PostDetailViewCell.self)) { row, element, cell in
                cell.mainImageView.image = UIImage(data: element)
            }
            .disposed(by: disposeBag)
        

    }
}

extension PostDetailViewController: PostDetailViewControllerDelegate {
    func reloadRequest() {
        guard let postID else { return }
        postIDInput.onNext(postID)
        delegate?.reloadRequest()
    }
}
