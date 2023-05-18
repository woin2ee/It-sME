//
//  TestScheduler+.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/17.
//

import Foundation
import RxTest

extension TestScheduler {
    
    /// 지정된 시간에 Void 타입 next 이벤트를 한 번만 방출하는 Hot observable 을 생성하여 반환합니다.
    /// - Parameter emitTime: 이벤트를 방출하는 시간입니다.
    /// - Returns: Element 타입이 Void 인 `TestableObservable`
    func createTrigger(emitAt emitTime: TestTime = 201) -> TestableObservable<Void> {
        return self.createHotObservable([.next(emitTime, ())])
    }
}
