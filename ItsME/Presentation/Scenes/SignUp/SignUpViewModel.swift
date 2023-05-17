//
//  SignUpViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/11.
//

import Foundation
import ItsMEUtil
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    
    private let userRepository: UserProfileRepository
    
    private let userNameForSignUp: String
    private let userEmailForSignUp: String
    
    init(userRepository: UserProfileRepository = .shared, userNameForSignUp: String, userEmailForSignUp: String) {
        self.userRepository = userRepository
        self.userNameForSignUp = userNameForSignUp
        self.userEmailForSignUp = userEmailForSignUp
    }
    
    func transform(input: Input) -> Output {
        let name = Driver<String>.just(userNameForSignUp)
        let email = Driver<String>.just(userEmailForSignUp)
        let birthday = input.birthday
            .map { ItsMESimpleDateFormatter.string(from: $0) }
        
        let userInfo = Driver.combineLatest(name,
                                            birthday,
                                            input.address,
                                            input.phoneNumber,
                                            email)
            .map { name, birthday, address, phoneNumber, email in
                return UserProfile(name: name,
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
                return self.userRepository.saveUserProfile($0) // TODO: Error handling
                    .asSignalOnErrorJustComplete()
            }
            .doOnNext { ItsMEUserDefaults.allowsAutoLogin = true }
        
        return .init(signUpComplete: signUpComplete)
    }
}

// MARK: - Input & Output

extension SignUpViewModel {
    
    struct Input {
        let birthday: Driver<Date?>
        let address: Driver<String>
        let phoneNumber: Driver<String>
        let startTrigger: Signal<Void>
    }
    
    struct Output {
        let signUpComplete: Signal<Void>
    }
}
