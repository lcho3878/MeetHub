//
//  MyPostViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/30/24.
//

import Foundation
import RxSwift

final class MyPostViewModel: ViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let requestInput: PublishSubject<Void>
    }
    struct Output {
        let postOutput: PublishSubject<[Post]>
        let errorOutput: PublishSubject<PostsResponseModel.ErrorModel?>
    }
    
    func transform(input: Input) -> Output {
        let postOutput = PublishSubject<[Post]>()
        let errorOutput = PublishSubject<PostsResponseModel.ErrorModel?>()
        
//        input.requestInput
//            .flatMap {
//                let userID = UserDefaultsManager.shared.userID
//                return APIManager.shared.callRequest(api: .userPost(userID: userID), type: PostsResponseModel.self)
//                    .catch { error in
//                        errorOutput.onNext(error as? PostsResponseModel.ErrorModel)
//                        return Single<PostsResponseModel>.never()
//                    }
//            }
//            .bind(with: self) { owner, response in
//                postOutput.onNext(response.data)
//            }
//            .disposed(by: disposeBag)
   
        
        return Output(
            postOutput: postOutput,
            errorOutput: errorOutput
        )
    }
}
