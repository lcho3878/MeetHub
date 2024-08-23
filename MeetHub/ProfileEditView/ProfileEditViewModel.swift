//
//  ProfileEditViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import Foundation
import RxSwift

final class ProfileEditViewModel: ViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let userOutput: PublishSubject<User>
    }
    
    func transform(input: Input) -> Output {
        
        let userOutput = PublishSubject<User>()
        
        APIManager.shared.callRequest(api: .myProfile, type: User.self)
            .asObservable()
            .bind { user in
                userOutput.onNext(user)
            }
            .disposed(by: disposeBag)
        
        return Output(userOutput: userOutput)
    }
}
