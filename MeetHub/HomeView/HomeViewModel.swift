//
//  HomeViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/21/24.
//

import Foundation
import RxSwift

final class HomeViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    var posts = PublishSubject<[Post]>()
    
    struct Input {
        
    }
    
    struct Output {
        let postOutput: PublishSubject<[Post]>
        let errorOutput: PublishSubject<Error>
    }
    
    func transform(input: Input) -> Output {
        let errorOutput = PublishSubject<Error>()
        APIManager.shared.callRequest(api: .lookUpPost, type: PostsResponseModel.self) { error in
            errorOutput.onNext(error)
        }
        .asObservable()
        .bind(with: self) { owner, value in
            owner.posts.onNext(value.data)
        }
        .disposed(by: disposeBag)

        

        return Output(postOutput: posts, errorOutput: errorOutput)
    }
}
