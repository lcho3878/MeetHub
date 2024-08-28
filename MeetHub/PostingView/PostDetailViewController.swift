//
//  PostDetailViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import UIKit
import RxSwift
import RxGesture

protocol PostDetailViewControllerDelegate: AnyObject {
    func reloadRequest()
}

final class PostDetailViewController: BaseViewController {
    
    var postID: String?
    
    var coord: Coord?
    
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
        let likeButtonTap = PublishSubject<Bool>()
        
        let input = PostDetailViewModel.Input(postIDInput: postIDInput, likeButtonTap: likeButtonTap)
        let output = viewModel.transform(input: input)
        postIDInput.onNext(postID)
        
        postDetailView.mapView.mapView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self, onNext: { owner, _ in
                let mapVC = MapviewController()
                mapVC.coord = owner.coord
                mapVC.viewType = .detail
                owner.navigationController?.pushViewController(mapVC, animated: true)
            })
        .disposed(by: disposeBag)
        
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
                owner.coord = post.content1?.asCoord()
                print(post.post_id)
                print(post.isLiked)
            }
            .disposed(by: disposeBag)
        
        output.imageDataOutput
            .bind(to: postDetailView.collectionView.rx.items(cellIdentifier: PostDetailViewCell.id, cellType: PostDetailViewCell.self)) { row, element, cell in
                cell.mainImageView.image = UIImage(data: element)
            }
            .disposed(by: disposeBag)
        
        output.likeStatusOutput
            .bind(with: self) { owner, isLike in
                owner.postDetailView.updateLikeButton(isLike)
            }
            .disposed(by: disposeBag)
        
        postDetailView.likeButton.rx.tap
            .withLatestFrom(output.likeStatusOutput)
            .bind(onNext: { isLike in
                print("좋아요 값 변경")
                likeButtonTap.onNext(isLike ? false : true)
            })
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

