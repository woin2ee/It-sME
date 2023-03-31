//
//  CoverLetterEditingViewModel.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/09.
//

import RxCocoa
import RxSwift

protocol CoverLetterEditingViewModelDelegate: AnyObject {
    func coverLetterEditingViewModelDidEndEditing(with coverLetterItem: CoverLetterItem, at indexPath: IndexPath)
    func coverLetterEditingViewModelDidAppend(coverLetterItem: CoverLetterItem)
}

final class CoverLetterEditingViewModel: ViewModelType {
    
    let coverLetterItem: CoverLetterItem
    let editingType: EditingType
    private weak var delegate: CoverLetterEditingViewModelDelegate?
    
    init(
        coverLetterItem: CoverLetterItem,
        editingType: EditingType,
        delegate: CoverLetterEditingViewModelDelegate? = nil
    ) {
        self.coverLetterItem = coverLetterItem
        self.editingType = editingType
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        
        let coverLetterItem = Driver.combineLatest(
            input.title,
            input.content
        ) {
            (title, content) -> CoverLetterItem in
            return .init(title: title, contents: content
            )
        }
            .startWith(coverLetterItem)
            
        
        let doneHandler = input.doneTrigger
            .withLatestFrom(coverLetterItem)
            .do(onNext: endEditing(with:))
            .mapToVoid()
                
        let editingType = Driver.just(editingType)
                
                return .init(
                    coverLetterItem: coverLetterItem,
                    doneHandler: doneHandler,
                    editingType: editingType
                )
                }
    
    private func endEditing(with coverLetterItem: CoverLetterItem) {
        switch editingType {
        case .edit(let indexPath):
            delegate?
                .coverLetterEditingViewModelDidEndEditing(with: coverLetterItem, at: indexPath)
        case .new:
            delegate?
                .coverLetterEditingViewModelDidAppend(coverLetterItem: coverLetterItem)
        }
    }
}

//MARK: - Input & Output
extension CoverLetterEditingViewModel {
    
    struct Input {
        let title: Driver<String>
        let content: Driver<String>
        let doneTrigger: Signal<Void>
    }
    
    struct Output {
        let coverLetterItem: Driver<CoverLetterItem>
        let doneHandler: Signal<Void>
        let editingType: Driver<EditingType>
    }
}

//MARK: - EditingType
extension CoverLetterEditingViewModel {
    
    enum EditingType {
        
        /// 기존 자기소개서 정보를 수정할 때 사용하는 열거형 값입니다.
        case edit(indexPath: IndexPath)
        
        /// 새 자기소개서를 추가할 때 사용하는 열거형 값입니다.
        case new
    }
}
