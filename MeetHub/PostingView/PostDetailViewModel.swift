//
//  PostDetailViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import Foundation
import RxSwift

final class PostDetailViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    private var imageDatas = [Data]()
    
    struct Input {
        let postIDInput: Observable<String>
        let likeButtonTap: PublishSubject<Bool>
    }
    
    struct Output {
        let postOutput: PublishSubject<Post>
        let imageDataOutput: PublishSubject<[Data]>
        let likeStatusOutput: PublishSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        let postOutput = PublishSubject<Post>()
        let imageDataOutput = PublishSubject<[Data]>()
        let likeStatusOutput = PublishSubject<Bool>()
        
        let postIDInput = input.postIDInput.share()
        
        postIDInput
            .flatMap {
                APIManager.shared.callRequest(api: .detailPost(postID: $0), type: Post.self)
            }
            .bind(with: self, onNext: { owner, post in
                postOutput.onNext(post)
                likeStatusOutput.onNext(post.isLiked)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(postIDInput, input.likeButtonTap)
            .map { postID, isLike in
                LikeQuery(postID: postID, body: LikeQuery.Body(like_status: isLike))
            }
            .flatMap {
                APIManager.shared.callRequest(api: .likePost(query: $0), type: LikeQuery.Body.self)
            }
            .bind(onNext: { value in
                likeStatusOutput.onNext(value.like_status)
            })
            
            .disposed(by: disposeBag)
        
        postOutput
            .bind(with: self, onNext: { owner, post in
                owner.imageDatas = []
                for file in post.files {
                    APIManager.shared.requestImageData(image: file) { data in
                        owner.imageDatas.append(data)
                        imageDataOutput.onNext(owner.imageDatas)
                    }
                }
                
            })
            .disposed(by: disposeBag)
        
        return Output(
            postOutput: postOutput, 
            imageDataOutput: imageDataOutput,
            likeStatusOutput: likeStatusOutput
        )
    }
}
