//
//  RxBaseTestCase.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/17.
//

import RxSwift
import RxTest
import XCTest

class RxBaseTestCase: XCTestCase {
    
    var disposeBag: DisposeBag!
    var testScheduler: TestScheduler!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        disposeBag = .init()
        testScheduler = .init(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        disposeBag = nil
        testScheduler = nil
    }
}
