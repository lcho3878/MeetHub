//
//  PostingViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostingViewModel: ViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let markerInput: PublishSubject<Coord>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        input.markerInput
            .bind(onNext: { coord in
                print(coord.lat, coord.lon)
            })
            .disposed(by: disposeBag)
        return Output()
    }
    
}
