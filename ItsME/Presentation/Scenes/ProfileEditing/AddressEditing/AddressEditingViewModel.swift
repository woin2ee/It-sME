//
//  AddressEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/05/04.
//

import RxSwift
import RxCocoa

protocol AddressEditingViewModelDelegate: AnyObject {
    func addressEditingViewModelDidEndEditing(with address: String)
}

final class AddressEditingViewModel: ViewModelType {

    let initialAddress: String

    weak var delegate: AddressEditingViewModelDelegate?

    init(initialAddress: String, delegate: AddressEditingViewModelDelegate?) {
        self.initialAddress = initialAddress
        self.delegate = delegate
    }

    func transform(input: Input) -> Output {
        let address = input.address
            .startWith(initialAddress)
        let saveComplete = input.saveTrigger
            .withLatestFrom(address)
            .doOnNext(delegate?.addressEditingViewModelDidEndEditing(with:))
            .mapToVoid()

        return .init(
            address: address,
            saveComplete: saveComplete
        )
    }
}

// MARK: - Input & Output

extension AddressEditingViewModel {

    struct Input {
        let address: Driver<String>
        let saveTrigger: Signal<Void>
    }

    struct Output {
        let address: Driver<String>
        let saveComplete: Signal<Void>
    }
}
