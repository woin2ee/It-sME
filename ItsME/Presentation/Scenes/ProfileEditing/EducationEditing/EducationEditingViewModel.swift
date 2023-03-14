//
//  EducationEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/28.
//

import RxSwift
import RxCocoa

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
        let graduateDateString = Driver.merge(
            input.graduateDate
                .startWith((year: educationItem.graduateYear ?? 0, month: educationItem.graduateMonth ?? 0))
                .map { return "\($0.year).\($0.month.toLeadingZero(digit: 2))" },
            input.enrollmentSelection
                .startWith(()) // 졸업일 초기 상태 지정
                .map { return "재학중" },
            input.graduateSelection
                .map {
                    let year = Calendar.current.currentYear
                    let month = Calendar.current.currentMonth
                    return "\(year).\(month.toLeadingZero(digit: 2))"
                }
        )
        
        let educationItem = Driver.combineLatest(
            input.title,
            input.description,
            input.entranceDate
                .startWith((
                    year: educationItem.entranceYear ?? Calendar.current.currentYear,
                    month: educationItem.entranceMonth ?? Calendar.current.currentMonth
                )), // 입학일 초기 상태 지정
            graduateDateString
        ) {
            (title, description, entranceDate, graduateDate) -> EducationItem in
            let period = "\(entranceDate.year).\(entranceDate.month.toLeadingZero(digit: 2)) - \(graduateDate)"
            return .init(period: period, title: title, description: description)
        }
            .startWith(educationItem)
        
        let doneHandler = input.doneTrigger
            .withLatestFrom(educationItem)
            .do(onNext: endEditing(with:))
            .mapToVoid()
        
        let editingType = Driver.just(editingType)
                
        return .init(
            educationItem: educationItem,
            doneHandler: doneHandler,
            editingType: editingType
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
        let entranceDate: Driver<(year: Int, month: Int)>
        let graduateDate: Driver<(year: Int, month: Int)>
        let doneTrigger: Signal<Void>
        let enrollmentSelection: Driver<Void>
        let graduateSelection: Driver<Void>
    }
    
    struct Output {
        let educationItem: Driver<EducationItem>
        let doneHandler: Signal<Void>
        let editingType: Driver<EditingType>
    }
}

// MARK: - EditingType

extension EducationEditingViewModel {
    
    enum EditingType {
        
        /// 기존 학력 정보를 수정할 때 사용하는 열거형 값입니다.
        case edit(indexPath: IndexPath? = nil)
        
        /// 새 학력 정보를 추가할 때 사용하는 열거형 값입니다.
        case new
    }
}
