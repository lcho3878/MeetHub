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
    
    private var datas = [Data]()
    
    struct Input {
        let markerInput: PublishSubject<Coord>
        let dataInput: PublishSubject<Data>
        let deleteTap: PublishSubject<Int>
        let uploadButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let datasOutput: PublishSubject<[Data]>
    }
    
    func transform(input: Input) -> Output {
        let datasOutput = PublishSubject<[Data]>()
        input.markerInput
            .bind(onNext: { coord in
                print(coord.lat, coord.lon)
            })
            .disposed(by: disposeBag)
        
        input.dataInput
            .bind(with: self, onNext: { owner, data in
                guard owner.datas.count < 5 else { return }
                owner.datas.append(data)
                datasOutput.onNext(owner.datas)
            })
            .disposed(by: disposeBag)
        
        input.deleteTap
            .bind(with: self) { owner, index in
                owner.datas.remove(at: index)
                datasOutput.onNext(owner.datas)
            }
            .disposed(by: disposeBag)
        
        input.uploadButtonTap
            .bind(with: self, onNext: { owner, _ in
                APIManager.shared.uploadFiles(datas: owner.datas)
            })
            .disposed(by: disposeBag)
        
        return Output(datasOutput: datasOutput)
    }
    
}

struct FilesModel: Decodable {
    let files: [String]
}
