//
//  HomeViewModel.swift
//  It'sME
//
//  Created by Jaewon Yun on 2022/11/09.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Signal<Void>
        let viewWillAppear: Signal<Void>
    }
    
    struct Output {
        let userInfo: Driver<UserProfile>
        let cvsInfo: Driver<[CVInfo]>
    }
    
    private let userRepository: UserProfileRepository
    private let cvRepository: CVRepository
    
    private(set) var userInfo: UserProfile
    
    init(userRepository: UserProfileRepository, cvRepository: CVRepository, userInfo: UserProfile = .empty) {
        self.userRepository = userRepository
        self.cvRepository = cvRepository
        self.userInfo = userInfo
    }
    
    func removeCV(cvInfo: CVInfo) -> Signal<Void> {
        return self.cvRepository.removeCV(by: cvInfo.uuid).asSignalOnErrorJustComplete()
    }
        
    func transform(input: Input) -> Output {
        let userInfo = Signal.merge(input.viewDidLoad, input.viewWillAppear.skip(1))
            .flatMap { _ in
                return self.userRepository.getUserProfile()
                    .asDriverOnErrorJustComplete()
                    .doOnNext { self.userInfo = $0 }
            }
        
        let cvsInfo = Signal.merge(input.viewDidLoad, input.viewWillAppear.skip(1))
            .flatMapLatest { _ in
                return self.cvRepository.getAllCV()
                    .asDriver(onErrorJustReturn: [])
            }
        
        return Output(
            userInfo: userInfo,
            cvsInfo: cvsInfo
        )
    }
}

