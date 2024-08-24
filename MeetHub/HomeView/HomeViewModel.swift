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
    
    private var next: String?
    
    private var posts = [Post]()
    
    private var postsOutput = PublishSubject<[Post]>()
    
    struct Input {
        let indexInput: BehaviorSubject<Int>
        let indexPathInput: PublishSubject<[IndexPath]>
    }
    
    struct Output {
        let menuOutput: Observable<[String]>
        let postOutput: PublishSubject<[Post]>
        let errorOutput: PublishSubject<Error>
    }
    
    func transform(input: Input) -> Output {
        let errorOutput = PublishSubject<Error>()
        
        func fetchPost(next: String?) {
            APIManager.shared.callRequest(api: .lookUpPost(next: next), type: PostsResponseModel.self) { error in
                errorOutput.onNext(error)
            }
            .asObservable()
            .bind(with: self) { owner, value in
                if next == nil {
                    owner.posts = value.data
                }
                else {
                    owner.posts.append(contentsOf: value.data)
                }
                owner.postsOutput.onNext(owner.posts)
                owner.next = value.next_cursor
            }
            .disposed(by: disposeBag)
        }
        
        fetchPost(next: next)
        
        input.indexInput
            .bind { index in
                // 메뉴 선택시 로직 구현
                print("\(self.menus[index]) 선택")
            }
            .disposed(by: disposeBag)
        
        input.indexPathInput
            .bind(with: self) { owner, indexPaths in
                for indexPath in indexPaths {
                    if indexPath.item == owner.posts.count - 4 && owner.next != "0" {
                        fetchPost(next: owner.next)
                    }
                }
            }
            .disposed(by: disposeBag)

        return Output(menuOutput: Observable.just(menus), postOutput: postsOutput, errorOutput: errorOutput)
    }
}
