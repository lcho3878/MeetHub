//
//  FilesModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import Foundation

struct FilesModel: Decodable, ResponseModel {
    let files: [String]
    
    struct ErrorModel: ResponseError {
        var responseCode: Int?
        
        init(responseCode: Int? = nil) {
            self.responseCode = responseCode
        }
        
        var errorMessage: String {
            switch responseCode {
            case 400: return "잘못된 요청입니다. 이미지의 크기는 5MB를 넘을 수 없습니다."
            case 401: return "인증할 수 없는 액세스 토큰입니다."
            case 403: return "Forbidden"
            default: return ""
            }
        }
    }
}
