//
//  YearMonthPickerView+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/03.
//

import RxSwift
import RxCocoa

extension Reactive where Base: YearMonthPickerView {

    var delegateProxy: DelegateProxy<YearMonthPickerView, YearMonthPickerViewDelegate> {
        YearMonthPickerViewDelegateProxy.proxy(for: base)
    }

    var selectedDate: ControlEvent<(year: Int, month: Int)> {
        let selector: Selector = #selector(YearMonthPickerViewDelegate.yearMonthPickerViewDidSelect(year:month:))
        let source = delegateProxy
            .methodInvoked(selector)
            .map { parameters in
                guard let year = parameters[0] as? Int else {
                    throw RxCocoaError.castingError(object: parameters[0], targetType: Int.self)
                }
                guard let month = parameters[1] as? Int else {
                    throw RxCocoaError.castingError(object: parameters[1], targetType: Int.self)
                }

                return (year: year, month: month)
            }

        return .init(events: source)
    }
}
