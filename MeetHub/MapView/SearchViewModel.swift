//
//  SearchViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let queryInput: ControlProperty<String>
    }
    
    struct Output {
        let resultOutput: PublishSubject<[Place]>
    }
    
    func transform(input: Input) -> Output {
        let resultOutput = PublishSubject<[Place]>()
        
        input.queryInput
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler())
            .flatMap { query in
                guard !query.isEmpty else { return Single<Response>.never() }
                return APIManager.shared.callRequest(api: .search(query: query), type: Response.self)
                    .catch { error in
                        print(" 좋버그 발생: \(error)")
                        return Single<Response>.never()
                    }
            }
            .bind { response in
                resultOutput.onNext(response.items)
                print("viewmodel에서 성공적으로 방출")
            }
            .disposed(by: disposeBag)
        return Output(resultOutput: resultOutput)
    }
}
