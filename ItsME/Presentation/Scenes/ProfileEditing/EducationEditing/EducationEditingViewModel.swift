//
//  EducationEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/28.
//

import RxSwift
import RxCocoa

protocol EducationEditingViewModelDelegate: AnyObject {
    func educationEditingViewModelDidEndEditing(with educationItem: EducationItem, at index: IndexPath.Index)
    func educationEditingViewModelDidAppend(educationItem: EducationItem)
    func educationEditingViewModelDidDeleteEducationItem(at index: IndexPath.Index)
}

final class EducationEditingViewModel: ViewModelType {
    
    let initalEducationItem: EducationItem
    let editingType: EditingType
    weak var delegate: EducationEditingViewModelDelegate?
    
    init(
        educationItem: EducationItem,
        editingType: EditingType,
        delegate: EducationEditingViewModelDelegate? = nil
    ) {
        self.initalEducationItem = educationItem
        self.editingType = editingType
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        let graduateDateString = Driver.merge(
            input.selectedGraduateDate
                .startWith((year: initalEducationItem.graduateYear ?? 0, month: initalEducationItem.graduateMonth ?? 0))
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
            input.selectedEntranceDate
                .startWith((
                    year: initalEducationItem.entranceYear ?? Calendar.current.currentYear,
                    month: initalEducationItem.entranceMonth ?? Calendar.current.currentMonth
                )), // 입학일 초기 상태 지정
            graduateDateString
        ) {
            (title, description, entranceDate, graduateDate) -> EducationItem in
            let period = "\(entranceDate.year).\(entranceDate.month.toLeadingZero(digit: 2)) - \(graduateDate)"
            return .init(period: period, title: title, description: description)
        }
            .startWith(initalEducationItem)
        
        let doneHandler = input.doneTrigger
            .withLatestFrom(educationItem)
            .doOnNext(endEditing(with:))
            .mapToVoid()
        
        let editingType = Driver.just(editingType)
        
        let deleteHandler = input.deleteTrigger
            .doOnNext {
                if case let .edit(index) = self.editingType {
                    self.delegate?.educationEditingViewModelDidDeleteEducationItem(at: index)
                }
            }
                
        return .init(
            educationItem: educationItem,
            doneHandler: doneHandler,
            editingType: editingType,
            deleteHandler: deleteHandler
        )
    }
    
    private func endEditing(with educationItem: EducationItem) {
        switch editingType {
        case .edit(let index):
            delegate?.educationEditingViewModelDidEndEditing(with: educationItem, at: index)
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
        let selectedEntranceDate: Driver<(year: Int, month: Int)>
        let selectedGraduateDate: Driver<(year: Int, month: Int)>
        let doneTrigger: Signal<Void>
        let enrollmentSelection: Driver<Void>
        let graduateSelection: Driver<Void>
        let deleteTrigger: Signal<Void>
    }
    
    struct Output {
        let educationItem: Driver<EducationItem>
        let doneHandler: Signal<Void>
        let editingType: Driver<EditingType>
        let deleteHandler: Signal<Void>
    }
}

// MARK: - EditingType

extension EducationEditingViewModel {
    
    enum EditingType {
        
        /// 기존 학력 정보를 수정할 때 사용하는 열거형 값입니다.
        case edit(index: IndexPath.Index)
        
        /// 새 학력 정보를 추가할 때 사용하는 열거형 값입니다.
        case new
    }
}
