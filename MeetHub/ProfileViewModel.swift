//
//  ProfileViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import Foundation
import RxSwift

final class ProfileViewModel: ViewModel {
    
    enum ProfileMenu: CaseIterable {
        case profileEdit
        case logout
        case donate
        
        var title: String {
            switch self {
            case .profileEdit:
                return  "내 프로필 수정"
            case .logout:
                return "로그아웃"
            case .donate:
                return "개발자에게 후원하기"
            }
        }
    }
    
    private let menus: [ProfileMenu] = ProfileMenu.allCases
    
    struct Input {
        let menuInput: PublishSubject<ProfileMenu>
        let requestInput: PublishSubject<Void>
    }
    struct Output {
        let menuOutput: Observable<[ProfileMenu]>
        let inquiryOutput: PublishSubject<User>
        let errorOutput: PublishSubject<User.ErrorModel?>
        let menuSelectOutput: PublishSubject<ProfileMenu>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let inquiryOutput = PublishSubject<User>()
        let errorOutput = PublishSubject<User.ErrorModel?>()
        let menuSelectOutput = PublishSubject<ProfileMenu>()

        
        input.menuInput
            .bind(with: self) { owner, menu in
                menuSelectOutput.onNext(menu)
            }
            .disposed(by: disposeBag)
        
        input.requestInput
            .flatMap {
                APIManager.shared.callRequest(api: .myProfile, type: User.self)
                    .catch { error in
                        errorOutput.onNext(error as? User.ErrorModel)
                        return Single<User>.never()
                    }
            }
            .bind(with: self) { owner, user in
                inquiryOutput.onNext(user)
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            menuOutput: Observable.just(menus),
            inquiryOutput: inquiryOutput,
            errorOutput: errorOutput,
            menuSelectOutput: menuSelectOutput
        )
    }
}
