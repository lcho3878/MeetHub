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
    
    private let menus = [
        "전체",
        "데이트",
        "맛집",
        "기타"
    ]
    
    private var posts = PublishSubject<[Post]>()
    
    struct Input {
        let indexInput: BehaviorSubject<Int>
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
        
        input.indexInput
            .bind { index in
                // 메뉴 선택시 로직 구현
                print("\(self.menus[index]) 선택")
            }
            .disposed(by: disposeBag)

        

        return Output(menuOutput: Observable.just(menus), postOutput: posts, errorOutput: errorOutput)
    }
}
