//
//  PhoneNumberEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/05/04.
//

import RxSwift
import RxCocoa

protocol PhoneNumberEditingViewModelDelegate: AnyObject {
    func phoneNumberEditingViewModelDidEndEditing(with phoneNumber: String)
}

final class PhoneNumberEditingViewModel: ViewModelType {
    
    let initialPhoneNumber: String
    
    weak var delegate: PhoneNumberEditingViewModelDelegate?
    
    init(initialPhoneNumber: String, delegate: PhoneNumberEditingViewModelDelegate) {
        self.initialPhoneNumber = initialPhoneNumber
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        let phoneNumber = input.phoneNumber
            .startWith(initialPhoneNumber)
        let saveComplete = input.saveTrigger
            .withLatestFrom(phoneNumber)
            .doOnNext(delegate?.phoneNumberEditingViewModelDidEndEditing(with:))
            .mapToVoid()
        
        return .init(
            phoneNumber: phoneNumber,
            saveComplete: saveComplete
        )
    }
}

// MARK: - Input & Output

extension PhoneNumberEditingViewModel {
    
    struct Input {
        let phoneNumber: Driver<String>
        let saveTrigger: Signal<Void>
    }
    
    struct Output {
        let phoneNumber: Driver<String>
        let saveComplete: Signal<Void>
    }
}
