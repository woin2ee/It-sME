//
//  YearMonthPickerViewDelegateProxy.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/03.
//

import RxSwift
import RxCocoa

final class YearMonthPickerViewDelegateProxy:
    DelegateProxy<YearMonthPickerView, YearMonthPickerViewDelegate>,
    DelegateProxyType {

    static func registerKnownImplementations() {
        self.register { parent in
            return .init(parentObject: parent, delegateProxy: self)
        }
    }

    static func currentDelegate(for object: YearMonthPickerView) -> YearMonthPickerViewDelegate? {
        object.yearMonthPickerViewDelegate
    }

    static func setCurrentDelegate(_ delegate: YearMonthPickerViewDelegate?, to object: YearMonthPickerView) {
        object.yearMonthPickerViewDelegate = delegate
    }
}

extension YearMonthPickerViewDelegateProxy: YearMonthPickerViewDelegate {}
