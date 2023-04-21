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
        let nameValidation = input.startTrigger
            .withLatestFrom(input.name)
            .map { $0.isNotEmpty }
        let addressValidation = input.startTrigger
            .withLatestFrom(input.address)
            .map { $0.isNotEmpty }
        let phoneNumberValidation = input.startTrigger
            .withLatestFrom(input.phoneNumber)
            .map { $0.isNotEmpty }
        let emailValidation = input.startTrigger
            .withLatestFrom(input.email)
            .map { $0.isNotEmpty }
        let signUpValidation = Signal.combineLatest(nameValidation,
                                                    addressValidation,
                                                    phoneNumberValidation,
                                                    emailValidation)
            .map { $0 && $1 && $2 && $3 }
        
        let birthday = input.birthday
            .map { ItsMESimpleDateFormatter.string(from: $0) }
        
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
            .withLatestFrom(signUpValidation)
            .filter { $0 == true }
            .withLatestFrom(userInfo)
            .flatMapFirst {
                return self.userRepository.saveUserInfo($0) // TODO: Error handling
                    .asSignalOnErrorJustComplete()
            }
            .doOnNext { ItsMEUserDefaults.allowsAutoLogin = true }
        
        return .init(
            signUpComplete: signUpComplete,
            nameValidation: nameValidation,
            addressValidation: addressValidation,
            phoneNumberValidation: phoneNumberValidation,
            emailValidation: emailValidation
        )
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
        let nameValidation: Signal<Bool>
        let addressValidation: Signal<Bool>
        let phoneNumberValidation: Signal<Bool>
        let emailValidation: Signal<Bool>
    }
}
