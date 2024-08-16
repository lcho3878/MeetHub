//
//  ViewModel.swift
//  MeetHub
//
//  Created by 이찬호 on 8/16/24.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
