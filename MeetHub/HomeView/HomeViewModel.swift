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
    
    private let menus = Observable.just([
        "전체",
        "데이트",
        "맛집",
        "기타"
    ])
    
    private var posts = PublishSubject<[Post]>()
    
    struct Input {
        
    }
    
    struct Output {
        let menuOutput: Observable<[String]>
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

        

        return Output(menuOutput: menus, postOutput: posts, errorOutput: errorOutput)
    }
}
