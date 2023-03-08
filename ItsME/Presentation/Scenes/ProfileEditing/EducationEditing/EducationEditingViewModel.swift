//
//  EducationEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/28.
//

import RxSwift
import RxCocoa

enum EditingType {
    
    /// 기존 학력 정보를 수정할 때 사용하는 열거형 값입니다.
    case edit(indexPath: IndexPath? = nil)
    
    /// 새 학력 정보를 추가할 때 사용하는 열거형 값입니다.
    case new
}

protocol EducationEditingViewModelDelegate: AnyObject {
    func educationEditingViewModelDidEndEditing(with educationItem: EducationItem, at indexPath: IndexPath?)
    func educationEditingViewModelDidAppend(educationItem: EducationItem)
}

final class EducationEditingViewModel: ViewModelType {
    
    let educationItem: EducationItem
    let editingType: EditingType
    private weak var delegate: EducationEditingViewModelDelegate?
    
    init(
        educationItem: EducationItem,
        editingType: EditingType,
        delegate: EducationEditingViewModelDelegate? = nil
    ) {
        self.educationItem = educationItem
        self.editingType = editingType
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        let educationItem = Driver.combineLatest(
            input.title,
            input.description,
            input.entranceDate
                .startWith(educationItem.entranceDate ?? ""),
            input.graduateDate
                .startWith(educationItem.graduateDate ?? "")
        ) {
            (title, description, entranceDate, graduateDate) -> EducationItem in
            let period = "\(entranceDate) - \(graduateDate)"
            return .init(period: period, title: title, description: description)
        }
            .startWith(educationItem)
        
        let doneHandler = input.doneTrigger
            .withLatestFrom(educationItem)
            .do(onNext: endEditing(with:))
            .mapToVoid()
        
        return .init(
            educationItem: educationItem,
            doneHandler: doneHandler
        )
    }
    
    private func endEditing(with educationItem: EducationItem) {
        switch editingType {
        case .edit(let indexPath):
            delegate?.educationEditingViewModelDidEndEditing(with: educationItem, at: indexPath)
        case .new:
            delegate?.educationEditingViewModelDidAppend(educationItem: educationItem)
        }
    }
}

// MARK: - Input & Output

extension EducationEditingViewModel {
    
    struct Input {
        let title: Driver<String>
        let description: Driver<String>
        let entranceDate: Driver<String>
        let graduateDate: Driver<String>
        let doneTrigger: Signal<Void>
    }
    
    struct Output {
        let educationItem: Driver<EducationItem>
        let doneHandler: Signal<Void>
    }
}
