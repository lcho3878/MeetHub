//
//  PostEditViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostEditViewModel: ViewModel {
    
    private let disposeBag = DisposeBag()
    
    private var imageDatas = [Data]()
    
    struct Input {
        let postIDInput: Observable<String>
        let titleInput: ControlProperty<String>
        let contentInput: ControlProperty<String>
        let markerInput: BehaviorSubject<Coord?>
        let dataInput: PublishSubject<Data>
        let deleteTap: PublishSubject<Int>
        let modifyButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let postOutput: PublishSubject<Post>
        let imageDataOutput: PublishSubject<[Data]>
    }
    
    func transform(input: Input) -> Output {
        let postOutput = PublishSubject<Post>()
        let imageDataOutput = PublishSubject<[Data]>()
        let files = PublishSubject<[String]>()
        let queryInput = Observable.combineLatest(input.titleInput, input.contentInput, input.markerInput, files, input.postIDInput)
        
        input.postIDInput
            .flatMap {
                APIManager.shared.callRequest(api: .detailPost(postID: $0), type: Post.self)
            }
            .bind(onNext: { post in
                postOutput.onNext(post)
            })
            .disposed(by: disposeBag)
        
        postOutput
            .bind(with: self, onNext: { owner, post in
                for file in post.files {
                    APIManager.shared.requestImageData(image: file) { data in
                        owner.imageDatas.append(data)
                        imageDataOutput.onNext(owner.imageDatas)
                        print("데이터추가")
                    }
 
                }
                
            })
            .disposed(by: disposeBag)
        
        input.dataInput
            .bind(with: self, onNext: { owner, data in
                guard owner.imageDatas.count < 5 else { return }
                owner.imageDatas.append(data)
                imageDataOutput.onNext(owner.imageDatas)
            })
            .disposed(by: disposeBag)
        
        input.deleteTap
            .bind(with: self) { owner, index in
                owner.imageDatas.remove(at: index)
                imageDataOutput.onNext(owner.imageDatas)
            }
            .disposed(by: disposeBag)
        
        input.modifyButtonTap
            .flatMap { [weak self] _ in
                guard let self, !self.imageDatas.isEmpty else {
                    files.onNext([])
                    return Single<FilesModel>.never()
                }
                return APIManager.shared.callRequest(api: .uploadFiles(files: self.imageDatas), type: FilesModel.self)
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
                let postQuery = PostQuery(title: $0.0, content: $0.1, content1: $0.2?.asString(), product_id: "MeetHub_meet", files: $0.3)
                dump(postQuery)
                let editQuery = PostEditQuery(postID: $0.4, query: postQuery)
                return editQuery
            }
            .flatMap {
                return APIManager.shared.callRequest(api: .editPost(query: $0), type: Post.self)
                    .catch { error in
                        return Single<Post>.never()
                    }
            }
            .bind { post in
                print("게시글 수정 성공")
            }
            .disposed(by: disposeBag)
        
        return Output(postOutput: postOutput, imageDataOutput: imageDataOutput)
    }
}
