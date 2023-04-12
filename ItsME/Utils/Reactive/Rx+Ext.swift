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
    
    func asSignalOnErrorJustComplete() -> Signal<Element> {
        return self.asSignal(onErrorSignalWith: .empty())
    }
}

extension ObservableType {
    
    func mapToVoid() -> Observable<Void> {
        return self.map { _ in }
    }
    
    func doOnNext(_ block: ((Element) -> Void)?) -> Observable<Element> {
        return self.do(onNext: block)
    }
}

extension SharedSequenceConvertibleType {
    
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return self.map { _ in }
    }
    
    func doOnNext(_ block: ((Element) -> Void)?) -> SharedSequence<SharingStrategy, Element> {
        return self.do(onNext: block)
    }
    
    func startWith(_ block: () -> Element) -> SharedSequence<SharingStrategy, Element> {
        return startWith(block())
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    
    func mapToVoid() -> PrimitiveSequence<Trait, Void> {
        return self.map { _ in }
    }
    
    func doOnSuccess(_ block: ((Element) throws -> Void)?) -> PrimitiveSequence<Trait, Element> {
        return self.do(onSuccess: block)
    }
}

extension PrimitiveSequenceType where Trait == MaybeTrait {
    
    func mapToVoid() -> PrimitiveSequence<Trait, Void> {
        return self.map { _ in }
    }
}
