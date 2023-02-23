//
//  IconInputViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/16.
//

import RxSwift
import RxCocoa

/**
`IconInputCell` 과 바인딩 되는 `ViewModel`
 
 `IconInputCell` 에서 이모지로 변환되어 보여줄 `UserInfoItemIcon` 객체를 `Relay` 로 가지고 있습니다.
 
 사용자가 아이콘을 선택할 때의 이벤트를 `Input` 으로 받아서 `Relay` 를 업데이트 합니다.
 */
final class IconInputViewModel: ViewModelType {
    
    struct Input {
        let newIcon: Driver<UserInfoItemIcon>
    }
    
    struct Output {
        let currentIcon: Driver<UserInfoItemIcon>
    }
    
    private let disposeBag: DisposeBag = .init()
    
    private let iconRelay: BehaviorRelay<UserInfoItemIcon>
    
    var currentIcon: UserInfoItemIcon {
        iconRelay.value
    }
    
    init(icon: UserInfoItemIcon) {
        self.iconRelay = .init(value: icon)
    }
    
    func transform(input: Input) -> Output {
        input.newIcon
            .skip(1)
            .drive(onNext: updateIcon)
            .disposed(by: disposeBag)
        let currentIcon = iconRelay.asDriver()
        
        return .init(currentIcon: currentIcon)
    }
}

extension IconInputViewModel {
    
    func updateIcon(_ icon: UserInfoItemIcon) {
        iconRelay.accept(icon)
    }
}
