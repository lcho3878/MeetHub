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
    
    private let menus = Menu.allCases
    
    private var menu: Menu?
    
    enum Menu: CaseIterable {
        case all
        case date
        case restaurant
        
        var menuTitle: String {
            switch self {
            case .all: return "전체"
            case .date: return "데이트"
            case .restaurant: return "맛집"
            }
        }
        
        func api(next: String?) -> Router {
            switch self {
            case .all:
                return .lookUpPost(next: next)
            default:
                return .hashTag(next: next, hashTag: menuTitle)
            }
        }
    }
    
    private var next: String?
    
    private var posts = [Post]()
    
    private var postsOutput = PublishSubject<[Post]>()
    
    struct Input {
        let menuInput: BehaviorSubject<Menu>
        let indexPathInput: PublishSubject<[IndexPath]>
        let reloadInput: PublishSubject<Void>
    }
    
    struct Output {
        let menuOutput: Observable<[Menu]>
        let postOutput: PublishSubject<[Post]>
        let errorOutput: PublishSubject<PostsResponseModel.ErrorModel?>
        let scrollTopOutput: PublishSubject<Void>
    }
    
    func transform(input: Input) -> Output {
        let errorOutput = PublishSubject<PostsResponseModel.ErrorModel?>()
        let scrollTopOutput = PublishSubject<Void>()
        
        func fetchPost(menu: Menu?) {
            guard let menu else { return }
            APIManager.shared.callRequestTest(api: menu.api(next: next), type: PostsResponseModel.self) { error in
                errorOutput.onNext(error as? PostsResponseModel.ErrorModel)
            }
            .asObservable()
            .bind(with: self) { owner, value in
                if owner.next == nil {
                    print("리로드는 여기로 ")
                    owner.posts = value.data
                    scrollTopOutput.onNext(())
                }
                else {
                    print("페이지네이션은 여기")
                    owner.posts.append(contentsOf: value.data)
                }
                owner.next = value.next_cursor
                owner.postsOutput.onNext(owner.posts)
                
            }
            .disposed(by: disposeBag)
        }
        
        input.menuInput
            .bind(with: self) { owner, menu in
                // 메뉴 선택시 로직 구현
                owner.menu = menu
                owner.next = nil
                fetchPost(menu: menu)
            }
            .disposed(by: disposeBag)
        
        input.indexPathInput
            .bind(with: self) { owner, indexPaths in
                for indexPath in indexPaths {
                    if indexPath.item == owner.posts.count - 4 && owner.next != "0" {
                        fetchPost(menu: owner.menu)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.reloadInput
            .bind(with: self, onNext: { owner, _ in
                owner.next = nil
                fetchPost(menu: owner.menu)
            })
            .disposed(by: disposeBag)

        return Output(menuOutput: Observable.just(menus), postOutput: postsOutput, errorOutput: errorOutput, scrollTopOutput: scrollTopOutput)
    }
}
