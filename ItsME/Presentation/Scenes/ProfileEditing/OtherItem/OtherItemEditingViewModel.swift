//
//  OtherItemEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/13.
//

import RxSwift
import RxCocoa

protocol OtherItemEditingViewModelDelegate: AnyObject {
    
    /// 항목 편집이 완료됐을때 호출되는 함수입니다.
    func otherItemEditingViewModelDidEndEditing(with otherItem: UserInfoItem, at index: IndexPath.Index?)
    
    /// 항목 추가가 완료됐을때 호출되는 함수입니다.
    func otherItemEditingViewModelDidAppend(otherItem: UserInfoItem)
}

final class OtherItemEditingViewModel: ViewModelType {
    
    let initalOtherItem: UserInfoItem
    let editingType: EditingType
    private weak var delegate: OtherItemEditingViewModelDelegate?
    
    init(
        initalOtherItem: UserInfoItem,
        editingType: EditingType,
        delegate: OtherItemEditingViewModelDelegate? = nil
    ) {
        self.initalOtherItem = initalOtherItem
        self.editingType = editingType
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        let userInfoItem = Driver.combineLatest(
            input.icon.startWith(initalOtherItem.icon),
            input.contents.startWith(initalOtherItem.contents)
        ) {
            UserInfoItem.init(icon: $0, contents: $1)
        }
        let editingType = Driver.just(editingType)
        let doneCompleted = input.doneTrigger
            .withLatestFrom(userInfoItem)
            .do(onNext: endEditing(with:))
            .mapToVoid()
        
        return .init(
            editingType: editingType,
            doneCompleted: doneCompleted,
            userInfoItem: userInfoItem
        )
    }
}

// MARK: - Input & Output

extension OtherItemEditingViewModel {
    
    struct Input {
        let doneTrigger: Signal<Void>
        let icon: Driver<UserInfoItemIcon>
        let contents: Driver<String>
    }
    
    struct Output {
        let editingType: Driver<EditingType>
        let doneCompleted: Signal<Void>
        let userInfoItem: Driver<UserInfoItem>
    }
}

// MARK: - Private Functions

private extension OtherItemEditingViewModel {
    
    func endEditing(with otherItem: UserInfoItem) {
        switch editingType {
        case .edit(let index):
            delegate?.otherItemEditingViewModelDidEndEditing(with: otherItem, at: index)
        case .new:
            delegate?.otherItemEditingViewModelDidAppend(otherItem: otherItem)
        }
    }
}

// MARK: - EditingType

extension OtherItemEditingViewModel {
    
    enum EditingType {
        
        /// 기존 정보를 수정할 때 사용하는 열거형 값입니다.
        case edit(index: IndexPath.Index? = nil)
        
        /// 새 정보를 추가할 때 사용하는 열거형 값입니다.
        case new
    }
}
