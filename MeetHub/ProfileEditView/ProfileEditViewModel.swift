//
//  ProfileEditViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileEditViewModel: ViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nicknameInput: ControlProperty<String>
        let imageDataInput: PublishSubject<Data?>
        let editButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let userOutput: PublishSubject<User>
    }
    
    func transform(input: Input) -> Output {
        
        let queryInput = Observable.combineLatest(input.nicknameInput, input.imageDataInput)
        let userOutput = PublishSubject<User>()
        
        APIManager.shared.callRequest(api: .myProfile, type: User.self)
            .asObservable()
            .bind { user in
                userOutput.onNext(user)
            }
            .disposed(by: disposeBag)
        
        input.editButtonTap
            .debug("버튼 클릭")
            .withLatestFrom(queryInput)
            .debug("쿼리")
            .map {
                ProfileEditQuery(nick: $0.0, profile: $0.1)
            }
            .debug("프로필 쿼리 생성")
            .bind(onNext: { query in
                APIManager.shared.profileEdit(query: query)
            })
            .disposed(by: disposeBag)
        
        return Output(userOutput: userOutput)
    }
}
