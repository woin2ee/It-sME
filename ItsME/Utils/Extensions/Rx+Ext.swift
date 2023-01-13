//
//  Rx+Ext.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/13.
//

import RxSwift
import RxCocoa

extension ObservableConvertibleType {
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return self.asDriver(onErrorDriveWith: .empty())
    }
}
