//
//  TotalCVViewModel.swift
//  ItsME
//
//  Created by MacBook Air on 2023/01/03.
//

import RxSwift
import RxCocoa

final class TotalCVViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Signal<Void>
    }
    
    struct Output {
        let userInfoItems: Driver<[UserInfoItem]>
        let educationItems: Driver<[EducationItem]>
        let cvInfo: Driver<CVInfo>
        
    }
    
    private let userRepository: UserRepository = .init()
    private let cvRepository: CVRepository = .init()
    
    private let behaviorRelay: BehaviorRelay<CVInfo>
    
    var resumeCategory: [ResumeCategory] {
        behaviorRelay.value.resume.category
    }
    
    var coverLetter: CoverLetter {
        behaviorRelay.value.coverLetter
    }
    
    init(cvInfo: CVInfo) {
        self.behaviorRelay = .init(value: cvInfo)
    }
    
    func transform(input: Input) -> Output {
        let userInfo = input.viewDidLoad
            .flatMapLatest { _ in
                self.userRepository.getUserInfo(byUID: "testUser") // FIXME: 유저 고유 ID 저장 방안 필요
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let cvInfo = behaviorRelay.asDriver()
        let userInfoItems = userInfo.map { $0.defaultItems + $0.otherItems }
        
        let educationItems = userInfo.map { $0.educationItems }
        
        
        return .init(
            userInfoItems: userInfoItems,
            educationItems: educationItems,
            cvInfo: cvInfo
        )
    }
}

// MARK: - International Function
extension TotalCVViewModel {
    func updateItems(_ item: [ResumeCategory]) {
        let itemsInfo = behaviorRelay.value
        itemsInfo.resume.category = item
        behaviorRelay.accept(itemsInfo)
    //    let userInfo = userInfoRelay.value
    //    userInfo.email.contents = email
    //    userInfoRelay.accept(userInfo)
    }
}

