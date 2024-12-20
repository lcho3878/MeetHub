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
        let imageDataInput: BehaviorSubject<Data?>

        let editButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let userOutput: PublishSubject<User>
        let successOutput: PublishSubject<Void>
        let errorOutput: PublishSubject<User.ErrorModel?>
    }
    
    func transform(input: Input) -> Output {
        
        let queryInput = Observable.combineLatest(input.nicknameInput, input.imageDataInput)
        let userOutput = PublishSubject<User>()
        let successOutput = PublishSubject<Void>()
        let errorOutput = PublishSubject<User.ErrorModel?>()
        
        APIManager.shared.callRequest(api: .myProfile, type: User.self)
            .asObservable()
            .bind { user in
                userOutput.onNext(user)
            }
            .disposed(by: disposeBag)
        
        input.editButtonTap
            .withLatestFrom(queryInput)
            .map {
                ProfileEditQuery(nick: $0.0, profile: $0.1)
            }
            .flatMap { query in
                APIManager.shared.callRequest(api: .editProfile(query: query), type: User.self)
                    .catch { error in
                        errorOutput.onNext(error as? User.ErrorModel)
                        return Single<User>.never()
                    }
            }
            .bind(onNext: { user in
                dump(user)
                successOutput.onNext(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            userOutput: userOutput,
            successOutput: successOutput,
            errorOutput: errorOutput
        )
    }
}


