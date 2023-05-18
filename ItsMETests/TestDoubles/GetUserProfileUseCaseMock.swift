//
//  GetUserProfileUseCaseMock.swift
//  ItsMETests
//
//  Created by Jaewon Yun on 2023/05/18.
//

@testable import ItsME
import RxSwift

struct GetUserProfileUseCaseMock: GetUserProfileUseCaseProtocol {
    
    var hasError: Bool
    let userProfile: UserProfile = .init(
        name: "name",
        profileImageURL: "profileImageURL",
        birthday: .init(icon: .cake, contents: "birthday"),
        address: .init(icon: .house, contents: "address"),
        phoneNumber: .init(icon: .phone, contents: "phoneNumber"),
        email: .init(icon: .letter, contents: "email"),
        otherItems: [.init(icon: .computer, contents: "otherItems")],
        educationItems: [.init(period: "period", title: "title", description: "description")]
    )
    
    func execute() -> Single<UserProfile> {
        if hasError {
            return .error(TestError.testError)
        } else {
            return .just(userProfile)
        }
    }
}
