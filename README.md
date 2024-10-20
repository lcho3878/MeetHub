# 밋허브(Meethub)
다른 사람들과 장소 및 정보를 공유할 수 있는 어플리케이션

## 🗓️ 개발기간

24.08.14 ~ 24.09.06

## 📷 스크린샷

|홈화면|게시글화면|글쓰기화면|프로핋화면|
|:-:|:-:|:-:|:-:|
|<img src="https://github.com/user-attachments/assets/14f9eda0-ff76-4c16-b6c7-8dc49f25ebbf" width="150"/>|<img src="https://github.com/user-attachments/assets/43ef0ffb-1e8a-4077-a76e-dd532113334a" width="150"/>|<img src="https://github.com/user-attachments/assets/4b65a014-21eb-4114-825c-0083e4f53734" width="150"/>|<img src="https://github.com/user-attachments/assets/63d08d63-2d21-4817-8061-ac6c89335837" width="150"/>|

|지도검색화면|지도화면|
|:-:|:-:|
|<img src="https://github.com/user-attachments/assets/9d5043d8-8b90-4d56-9ca2-0a36ef074f0d" width="150"/>|<img src="https://github.com/user-attachments/assets/a92e7edc-f184-477a-b41f-24947dcbf260" width="150"/>|

## 🛠️ 기술스택

* UIKit
* MVVM
* RxSwift
* Alamofire
* iamport-ios
* Tabmen

## 📌 기술스택 관련 기능

* MVVM
  * Input, Output, transform 프로토콜 적용

  * ViewModelProtocol을 통한 ViewModel 추상화

* RxSwift
  * ViewModel과 ViewController 데이터 바인딩

* Alamofire
  * Rest API 요청 및 응답 처리
    
  * Router 및 TargetType 패턴 적용을 통한 네트워크 통신 로직 추상화

* iamport-ios
  * 개발자 후원(결제기능) 구현

* Tabmen
  * ViewController 내부 상단 Tabbar구현

## 📱 화면별 기능

* 홈화면
  - 전체 게시글들을 조회할 수 있습니다. 해시태그를 기반으로 데이트, 맛집을 검색할 수 있습니다.

* 게시글 화면
  - 게시글에 첨부된 사진 및 지도를 볼 수 있고, 내 게시글이라면 수정 삭제가 가능합니다. 게시글이 마음에 든다면 추천, 줄겨찾기가 가능합니다.

* 글쓰기 화면, 지도 화면

  - 게시글의 제목, 내용 및 해시태그를 포함하여 게시글을 작성할 수 있습니다.
  
  - 하단의 사진모양 아이콘을 클릭하여 이미지를 첨부할 수 있습니다.
    
  - 지도 추가하기 버튼을 클릭하여 지도에서 직접 위치를 지정하거나 검색하여 위치를 공유할 수 있습니다.
    
  - 게시글 수정화면도 게시글 작성과 동일하게 진행됩니다.

* 프로필 화면
  - 내 프로필 정보를 수정, 로그아웃, 개발자에게 후원하기 기능이 있습니다.
    
  - 하단의 뷰를 통해 내가 쓴 게시물, 북마크한 게시물, 추천 게시글을 확인하고 게시글 조회가 가능합니다.

## 💥 트러블슈팅

* 서버에 전달할 수 있는 데이터 타입의 제한사항

  - 서버에 전달할 수 있는 일부 데이터의 형식이 String으로 제한되어, 좌표값을 위한 [Double]을 전달할 수 없었다.

  - Coord 타입 ([Double])을 만들고 String과 Coord에 각각 asCoord, asString이라는 함수를 생성하여 서버에 주고받는 데이터의 형식을 String으로 변환하고, 받아온 String을 Coord로 변환하는 방식으로 해결하였다.

  - 코드
    
    ```swift
    struct Coord {
        let lat: Double
        let lon: Double
        
        func asString() -> String {
            return "[\(self.lat), \(self.lon)]"
        }
    }
    
    extension String {
        static let formatter = DateFormatter()
        
        func asCoord() -> Coord? {
            let trimmedString = self.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
            let components = trimmedString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            if let lat = Double(components.first ?? ""), let lon = Double(components.last ?? "") {
                return Coord(lat: lat, lon: lon)
            } else {
                return nil
            }
        }
    }
    ```
* 네트워크 에러코드 핸들링 관련

  - 같은 statusCode로 응답이 와도 요청에 따라 코드값만 같을 뿐 에러의 내용이 달랐다.

  - ResponseModel, ResponseError 프로토콜을 구현하여 모든 ResponseModel이 Error을 가지도록 제한하여 에러 발생시 대응할 수 있도록 하였다.
    
  - 코드
 
    ```swift
    protocol ResponseModel: Decodable {
        associatedtype ErrorModel: ResponseError
    }
    
    protocol ResponseError: Error {
        var responseCode: Int? { get }
        var errorMessage: String { get }
        
        init(responseCode: Int?)
    }
    ```
