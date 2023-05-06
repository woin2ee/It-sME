//
//  UseCase.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/05/06.
//

protocol UseCase {
    
    associatedtype Input
    associatedtype Output
    
    func execute(input: Input) throws -> Output
}
