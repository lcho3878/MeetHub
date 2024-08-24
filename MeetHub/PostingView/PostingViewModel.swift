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
        let titleInput: ControlProperty<String>
        let contentInput: ControlProperty<String>
        let markerInput: BehaviorSubject<Coord?>
        let dataInput: PublishSubject<Data>
        let deleteTap: PublishSubject<Int>
        let uploadButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let datasOutput: PublishSubject<[Data]>
    }
    
    func transform(input: Input) -> Output {
        let datasOutput = PublishSubject<[Data]>()
        let files = PublishSubject<[String]>()
        let queryInput = Observable.combineLatest(input.titleInput, input.contentInput, input.markerInput, files)
        
        
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
            .flatMap { [weak self] _ in
                guard let self, !self.datas.isEmpty else {
                    files.onNext([])
                    return Single<FilesModel>.never()
                }
                return APIManager.shared.callRequest(api: .uploadFiles(files: self.datas), type: FilesModel.self)
                    .catch { error in
                        return Single<FilesModel>.never()
                    }
            }
            .bind(onNext: { value in
                files.onNext(value.files)
            })
            .disposed(by: disposeBag)

        files
            .withLatestFrom(queryInput)
            .map {
                PostQuery(title: $0.0, content: $0.1, content1: $0.2?.asString(), product_id: "MeetHub_meet", files: $0.3)
            }
            .flatMap {
                return APIManager.shared.callRequest(api: .uploadPost(query: $0), type: Post.self)
                    .catch { error in
                        return Single<Post>.never()
                    }
            }
            .bind { post in
                print("게시글 업로드 성공")
            }
            .disposed(by: disposeBag)

        return Output(datasOutput: datasOutput)
    }
    
}


