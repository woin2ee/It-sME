//
//  XCTest+Rx+.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/18.
//

import Foundation
import RxSwift
import RxTest

func XCTAssertRecordedElements(_ stream: [Recorded<Event<Void>>], _ elements: [Void], file: StaticString = #file, line: UInt = #line) {
    let equatableStream = stream.map { recorded in
        switch recorded.value {
        case .next:
            return Recorded.next(recorded.time, true)
        case .error(let error):
            return Recorded.error(recorded.time, error)
        case .completed:
            return Recorded.completed(recorded.time)
        }
    }
    let equatableElements = elements.map { true }
    XCTAssertRecordedElements(equatableStream, equatableElements)
}
