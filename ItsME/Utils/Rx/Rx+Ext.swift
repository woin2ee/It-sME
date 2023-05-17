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

extension ObservableConvertibleType where Element == Void {
    
    func asSignalOnErrorJustNext() -> Signal<Element> {
        return self.asSignal(onErrorJustReturn: ())
    }
}

extension ObservableType {
    
    func mapToVoid() -> Observable<Void> {
        return self.map { _ in }
    }
    
    func doOnNext(_ block: ((Element) throws -> Void)?) -> Observable<Element> {
        return self.do(onNext: block)
    }
    
    func doOnCompleted(_ block: (() throws -> Void)?) -> Observable<Element> {
        return self.do(onCompleted: block)
    }
    
    func unwrapOrThrow<Result>() -> Observable<Result> where Element == Result? {
        return self.map { try ItsME.unwrapOrThrow($0) }
    }
}

extension SharedSequenceConvertibleType {
    
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return self.map { _ in }
    }
    
    func doOnNext(_ block: ((Element) -> Void)?) -> SharedSequence<SharingStrategy, Element> {
        return self.do(onNext: block)
    }
    
    func doOnCompleted(_ block: (() -> Void)?) -> SharedSequence<SharingStrategy, Element> {
        return self.do(onCompleted: block)
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
    
    func unwrapOrThrow<Result>() -> PrimitiveSequence<Trait, Result> where Element == Result? {
        return self.map { try ItsME.unwrapOrThrow($0) }
    }
}

extension PrimitiveSequenceType where Trait == MaybeTrait {
    
    func mapToVoid() -> PrimitiveSequence<Trait, Void> {
        return self.map { _ in }
    }
}

extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Never {
    
    func andThenJustNext() -> Single<Void> {
        return self.andThen(.just(()))
    }
}
