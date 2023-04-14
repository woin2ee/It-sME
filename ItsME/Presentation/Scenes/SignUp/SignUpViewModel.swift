//
//  SignUpViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/11.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    
    private let userRepository: UserRepository
    
    init() {
        self.userRepository = .shared
    }
    
    func transform(input: Input) -> Output {
        let birthday = input.birthday
            .map { ItsMEDateFormatter.birthdayString(from: $0) }
        
        let userInfo = Driver.combineLatest(input.name,
                                            birthday,
                                            input.address,
                                            input.phoneNumber,
                                            input.email)
            .map { name, birthday, address, phoneNumber, email in
                return UserInfo(name: name,
                                profileImageURL: "",
                                birthday: .init(icon: .cake, contents: birthday),
                                address: .init(icon: .house, contents: address),
                                phoneNumber: .init(icon: .phone, contents: phoneNumber),
                                email: .init(icon: .letter, contents: email),
                                otherItems: [],
                                educationItems: [])
            }
        
        let signUpComplete = input.startTrigger
            .withLatestFrom(userInfo)
            .flatMapFirst {
                return self.userRepository.saveUserInfo($0) // TODO: Error handling
                    .asSignalOnErrorJustComplete()
            }
            .doOnNext { ItsMEUserDefaults.allowsAutoLogin = true }
        
        return .init(signUpComplete: signUpComplete)
    }
}

// MARK: - Input & Output

extension SignUpViewModel {
    
    struct Input {
        let name: Driver<String>
        let birthday: Driver<Date>
        let address: Driver<String>
        let phoneNumber: Driver<String>
        let email: Driver<String>
        let startTrigger: Signal<Void>
    }
    
    struct Output {
        let signUpComplete: Signal<Void>
    }
}
