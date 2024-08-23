//
//  ProfileViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import Foundation
import RxSwift

final class ProfileViewModel: ViewModel {
    
    enum ProfileMenu {
        case profileInquiry
        case profileEdit
        case logout
        
        var title: String {
            switch self {
            case .profileInquiry:
                return "내 프로필 조회"
            case .profileEdit:
                return  "내 프로필 수정"
            case .logout:
                return "로그아웃"
            }
        }
    }
    
    private let menus: [ProfileMenu] = [.profileInquiry, .profileEdit, .logout]
    
    struct Input {
        let menuInput: PublishSubject<ProfileMenu>
    }
    struct Output {
        let menuOutput: Observable<[ProfileMenu]>
        let inquiryOutput: PublishSubject<User>
        let editOutput: PublishSubject<Void>
        let logoutOutput: PublishSubject<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let inquiryOutput = PublishSubject<User>()
        let editOutput = PublishSubject<Void>()
        let logoutOutput = PublishSubject<Void>()
        input.menuInput
            .bind(with: self) { owner, menu in
                switch menu {
                case .profileInquiry:
                    APIManager.shared.callRequest(api: .myProfile, type: User.self)
                        .asObservable()
                        .bind { user in
                            inquiryOutput.onNext(user)
                        }
                        .disposed(by: owner.disposeBag)
                case .profileEdit:
                    editOutput.onNext(())
                case .logout:
                    logoutOutput.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(menuOutput: Observable.just(menus), inquiryOutput: inquiryOutput, editOutput: editOutput, logoutOutput: logoutOutput)
    }
}
