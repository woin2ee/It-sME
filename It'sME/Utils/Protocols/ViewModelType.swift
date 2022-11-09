//
//  ViewModelType.swift
//  It'sME
//
//  Created by Jaewon Yun on 2022/11/09.
//

import Foundation

protocol ViewModelType {
    
    /// ViewController 로부터 받을 User Interaction 타입
    associatedtype Input
    
    /// User Interaction 에 대한 응답 타입
    associatedtype Output
    
    /// User Interaction 을 응답으로 변환하는 함수
    ///
    /// User Interaction 에 대해 어떻게 처리를 하고 어떤 응답으로 돌려줄지 정의합니다.
    func transform(input: Input) -> Output
}
