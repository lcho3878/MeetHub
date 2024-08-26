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
    }
    
    struct Output {
        let postOutput: PublishSubject<Post>
        let imageDataOutput: PublishSubject<[Data]>
    }
    
    func transform(input: Input) -> Output {
        let postOutput = PublishSubject<Post>()
        let imageDataOutput = PublishSubject<[Data]>()
        input.postIDInput
            .flatMap {
                APIManager.shared.callRequest(api: .detailPost(postID: $0), type: Post.self)
            }
            .bind(onNext: { post in
                print("post response")
                postOutput.onNext(post)
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
        
        return Output(postOutput: postOutput, imageDataOutput: imageDataOutput)
    }
}
