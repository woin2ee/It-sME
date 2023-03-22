//
//  CategoryAddingViewModel.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/22.
//

import RxSwift
import RxCocoa

protocol CategoryAddingViewModelDelegate: AnyObject {
    func categoryAddingViewModelDidEndEditing(with resumeCategory: ResumeCategory, at section: Int?)
    func categoryAddingViewModelDidAppend(resumeCategory: ResumeCategory)
}

final class CategoryAddingViewModel: ViewModelType {
    
    private let resumeCategoryRelay: BehaviorRelay<ResumeCategory>
    
    let resumeCategory: ResumeCategory
    let editingType: EditingType
    private weak var delegate: CategoryAddingViewModelDelegate?
    
    
    init(
        resumeCategory: ResumeCategory,
         editingType: EditingType,
         delegate: CategoryAddingViewModelDelegate? = nil
    ) {
        self.resumeCategory = resumeCategory
        self.editingType = editingType
        self.delegate = delegate
        self.resumeCategoryRelay = .init(value: resumeCategory)
    }
    
    var currentResumeItem: [ResumeItem] {
        resumeCategoryRelay.value.items
    }
    
    func transform(input: Input) -> Output {
        
        let resumeCategory = Driver.combineLatest(input.title, Driver.just(currentResumeItem)) { (title, items) -> ResumeCategory in
            return .init(title: title, items: items)
        }
            .startWith(resumeCategory)
        
        let doneHandler = input.doneTrigger
            .withLatestFrom(resumeCategory)
            .do(onNext: endEditing(with:))
            .mapToVoid()
                
                let editingType = Driver.just(editingType)
                
                return .init(
                    resumeCategory: resumeCategory,
                    doneHandler: doneHandler,
                    editingType: editingType
                )
                }
    
    private func endEditing(with resumeCategory: ResumeCategory) {
        switch editingType {
        case .edit(let section):
            delegate?
                .categoryAddingViewModelDidEndEditing(with: resumeCategory, at: section)
        case .new:
            delegate?
                .categoryAddingViewModelDidAppend(resumeCategory: resumeCategory)
        }
    }
}


extension CategoryAddingViewModel {
    
    struct Input {
        let title: Driver<String>
        let doneTrigger: Signal<Void>
    }
    
    struct Output {
        let resumeCategory: Driver<ResumeCategory>
        let doneHandler: Signal<Void>
        let editingType: Driver<EditingType>
    }
}

//MARK: - EditingType
extension CategoryAddingViewModel {
    
    enum EditingType {
        
        /// 기존 자기소개서 정보를 수정할 때 사용하는 열거형 값입니다.
        case edit(section: Int? = nil)
        
        /// 새 자기소개서를 추가할 때 사용하는 열거형 값입니다.
        case new
    }
}
