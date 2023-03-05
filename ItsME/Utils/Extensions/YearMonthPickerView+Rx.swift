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
    
    var dateSelected: ControlEvent<(year: Int, month: Int)> {
        let selector: Selector = #selector(YearMonthPickerViewDelegate.yearMonthPickerViewDidSelect(year:month:))
        let source = delegateProxy
            .methodInvoked(selector)
            .map { parameters in
                guard let year = parameters[0] as? Int,
                      let month = parameters[1] as? Int else {
                    fatalError("\(#file) \(#line) yearMonthPickerViewDidSelect(year:month:) 함수의 파라미터와 일치하지 않습니다.")
                }
                return (year: year, month: month)
            }
        
        return .init(events: source)
    }
}
