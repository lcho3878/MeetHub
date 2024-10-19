밋허브(Meethub)

다른 사람들과 장소 및 정보를 공유할 수 있는 어플리케이션

개발기간

24.08.14 ~ 24.09.06

기술스택

UIKit, RxSwift, MVVM, Alamofire, iamport-ios, Tabmen, NetworkdMonitor

기술스택 관련 기능

MVVM: Input, Output 패턴 적용
Combine: ViewModel DataBinding 적용
Alamofire: API Response


기능설명

홈화면

전체 게시글들을 조회할 수 있습니다. 해시태그를 기반으로 데이트, 맛집을 검색할 수 있습니다.

게시글 화면

게시글에 첨부된 사진 및 지도를 볼 수 있고, 내 게시글이라면 수정 삭제가 가능합니다.

게시글이 마음에 든다면 추천, 줄겨찾기가 가능합니다.

글쓰기 화면

게시글의 제목, 내용 및 해시태그를 포함하여 게시글을 작성할 수 있습니다.

하단의 사진모양 아이콘을 클릭하여 이미지를 첨부할 수 있습니다.

지도 추가하기 버튼을 클릭하여 지도에서 직접 위치를 지정하거나 검색하여 위치를 공유할 수 있습니다.

게시글 수정화면도 게시글 작성과 동일하게 진행됩니다.

프로필 화면

내 프로필 정보를 수정, 회원탈퇴 및 로그아웃, 개발자에게 후원하기 기능이 있습니다.

하단의 뷰를 통해 내가 쓴 게시물, 북마크한 게시물, 추천 게시글을 확인하고 게시글 조회가 가능합니다.

트러블슈팅

서버에 전달할 수 있는 데이터 타입의 제한사항

서버에 전달할 수 있는 일부 데이터의 형식이 String으로 제한되어, 좌표값을 위한 [Double]을 전달할 수 없었다.

Coord 타입 ([Double])을 만들고 String과 Coord에 각각 asCoord, asString이라는 함수를 생성하여 

서버에 주고받는 데이터의 형식을 String으로 변환하고, 받아온 String을 Coord로 변환하는 방식으로 해결하였다.


네트워크 에러코드 핸들링 관련

같은 statusCode로 응답이 와도 요청에 따라 코드값만 같을 뿐 에러의 내용이 달랐다.

ResponseModel, ResponseError 프로토콜을 구현하여 모든 ResponseModel이 Error을 가지도록 제한하여 에러 발생시 대응할 수 있도록 하였다.
