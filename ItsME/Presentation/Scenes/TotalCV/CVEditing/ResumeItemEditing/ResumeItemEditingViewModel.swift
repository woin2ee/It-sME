//
//  ResumeItemEditingViewModel.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/07.
//

import RxSwift
import RxCocoa

enum ProgressStatus: String {
    case progress = "진행중"
    case finish = "종료"
}

protocol ResumeItemEditingViewModelDelegate: AnyObject {
    func resumeItemEditingViewModelDidEndEditing(with resumeItem: ResumeItem, at indexPath: IndexPath)
    func resumeItemEditingViewModelDidAppend(with resumeItem: ResumeItem, at section: Int)
}

final class ResumeItemEditingViewModel: ViewModelType {
    
    let editingType: EditingType
    private weak var delegate: ResumeItemEditingViewModelDelegate?
    
    init(
        editingType: EditingType,
        delegate: ResumeItemEditingViewModelDelegate?
    ) {
        self.editingType = editingType
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        let currentYear = Calendar.current.component(.year, from: .now)
        let currentMonth = Calendar.current.component(.month, from: .now)
        
        let editingType = Driver.just(editingType)
        
        let progressStatus = input.selectedProgressStatus
            .startWith {
                switch self.editingType {
                case .edit(_, let editingTarget):
                    if let endDate = editingTarget.endDate,
                       endDate == ProgressStatus.finish.rawValue {
                        return .progress
                    } else {
                        return .finish
                    }
                case .new:
                    return .finish
                }
            }
        
        let title = input.title
            .startWith {
                if case let .edit(_, target) = self.editingType {
                    return target.title
                } else {
                    return ""
                }
            }
        
        let secondTitle = input.secondTitle
            .startWith {
                if case let .edit(_, target) = self.editingType {
                    return target.secondTitle
                } else {
                    return ""
                }
            }
        
        let description = input.description
            .startWith {
                if case let .edit(_, target) = self.editingType {
                    return target.description
                } else {
                    return ""
                }
            }
        
        let startDate = input.selectedStartDate
            .startWith {
                if case let .edit(_, target) = self.editingType {
                    return (target.startYear ?? currentYear, target.startMonth ?? currentMonth)
                } else {
                    return (currentYear, currentMonth)
                }
            }
        
        let endDate = input.selectedEndDate
            .startWith {
                if case let .edit(_, target) = self.editingType {
                    return (target.endYear ?? currentYear, target.endMonth ?? currentMonth)
                } else {
                    return (currentYear, currentMonth)
                }
            }
        
        let resumeItem = Driver.combineLatest(
            title,
            secondTitle,
            description,
            startDate.map { "\($0.year).\($0.month.toLeadingZero(digit: 2))" },
            endDate.map { "\($0.year).\($0.month.toLeadingZero(digit: 2))" },
            progressStatus
        ) { title, secondTitle, description, startDateString, endDateString, progressStatus in
            let period: String
            switch progressStatus {
            case .progress:
                period = "\(startDateString) - \(ProgressStatus.progress.rawValue)"
            case .finish:
                period = "\(startDateString) - \(endDateString)"
            }
            return ResumeItem(period: period,
                              title: title,
                              secondTitle: secondTitle,
                              description: description)
        }
        
        let doneComplete = input.doneTrigger
            .withLatestFrom(resumeItem)
            .doOnNext(endEditing(with:))
            .mapToVoid()
        
        return .init(
            title: title,
            secondTitle: secondTitle,
            description: description,
            startDate: startDate,
            endDate: endDate,
            doneComplete: doneComplete,
            editingType: editingType,
            progressStatus: progressStatus
        )
    }
    
    private func endEditing(with resumeItem: ResumeItem) {
        switch editingType {
        case .edit(let indexPath, _):
            delegate?.resumeItemEditingViewModelDidEndEditing(with: resumeItem, at: indexPath)
        case .new(let section):
            delegate?.resumeItemEditingViewModelDidAppend(with: resumeItem, at: section)
        }
    }
}

// MARK: - Input & Output

extension ResumeItemEditingViewModel {
    
    struct Input {
        let title: Driver<String>
        let secondTitle: Driver<String>
        let description: Driver<String>
        let selectedStartDate: Driver<(year: Int, month: Int)>
        let selectedEndDate: Driver<(year: Int, month: Int)>
        let doneTrigger: Signal<Void>
        let selectedProgressStatus: Driver<ProgressStatus>
    }
    
    struct Output {
        let title: Driver<String>
        let secondTitle: Driver<String>
        let description: Driver<String>
        let startDate: Driver<(year: Int, month: Int)>
        let endDate: Driver<(year: Int, month: Int)>
        let doneComplete: Signal<Void>
        let editingType: Driver<EditingType>
        let progressStatus: Driver<ProgressStatus>
    }
}

// MARK: - EditingType

extension ResumeItemEditingViewModel {
    
    enum EditingType {
        
        /// 기존 카테고리 정보를 수정할 때 사용하는 열거형 값입니다.
        case edit(indexPath: IndexPath, resumeItem: ResumeItem)
        
        /// 새 카테고리를 추가할 때 사용하는 열거형 값입니다.
        case new(section: Int)
    }
}
