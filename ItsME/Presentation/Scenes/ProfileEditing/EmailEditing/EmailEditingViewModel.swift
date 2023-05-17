//
//  EmailEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/05/04.
//

import RxSwift
import RxCocoa

protocol EmailEditingViewModelDelegate: AnyObject {
    func emailEditingViewModelDidEndEditing(with email: String)
}

final class EmailEditingViewModel: ViewModelType {
    
    let initialEmail: String
    
    weak var delegate: EmailEditingViewModelDelegate?
    
    init(initialEmail: String, delegate: EmailEditingViewModelDelegate?) {
        self.initialEmail = initialEmail
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        let email = input.email
            .startWith(initialEmail)
        let saveComplete = input.saveTrigger
            .withLatestFrom(email)
            .doOnNext(delegate?.emailEditingViewModelDidEndEditing(with:))
            .mapToVoid()
        
        return .init(
            email: email,
            saveComplete: saveComplete
        )
    }
}

// MARK: - Input & Output

extension EmailEditingViewModel {
    
    struct Input {
        let email: Driver<String>
        let saveTrigger: Signal<Void>
    }
    
    struct Output {
        let email: Driver<String>
        let saveComplete: Signal<Void>
    }
}
