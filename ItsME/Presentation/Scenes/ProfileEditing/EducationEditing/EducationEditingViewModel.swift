//
//  EducationEditingViewModel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/28.
//

import RxSwift
import RxCocoa

enum SchoolEnrollmentStatus: String {
    case enrolled = "재학중"
    case graduated = "졸업"
}

protocol EducationEditingViewModelDelegate: AnyObject {
    func educationEditingViewModelDidEndEditing(with educationItem: Education, at index: IndexPath.Index)
    func educationEditingViewModelDidAppend(educationItem: Education)
    func educationEditingViewModelDidDeleteEducationItem(at index: IndexPath.Index)
}

final class EducationEditingViewModel: ViewModelType {

    let editingType: EditingType
    weak var delegate: EducationEditingViewModelDelegate?

    init(
        editingType: EditingType,
        delegate: EducationEditingViewModelDelegate? = nil
    ) {
        self.editingType = editingType
        self.delegate = delegate
    }

    func transform(input: Input) -> Output {
        let currentYear = Calendar.current.component(.year, from: .now)
        let currentMonth = Calendar.current.component(.month, from: .now)

        let editingType = Driver.just(editingType)

        let schoolEnrollmentStatus = input.selectedEnrollmentStatus
            .startWith {
                switch self.editingType {
                case .edit(_, let editingTarget):
                    if let graduateDate = editingTarget.graduateDate,
                       graduateDate == SchoolEnrollmentStatus.enrolled.rawValue {
                        return .enrolled
                    } else {
                        return .graduated
                    }
                case .new:
                    return .graduated
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

        let description = input.description
            .startWith {
                if case let .edit(_, target) = self.editingType {
                    return target.description
                } else {
                    return ""
                }
            }

        let entranceDate = input.selectedEntranceDate
            .startWith {
                if case let .edit(_, target) = self.editingType {
                    return (target.entranceYear ?? currentYear, target.entranceMonth ?? currentMonth)
                } else {
                    return (currentYear, currentMonth)
                }
            }

        let graduateDate = input.selectedGraduateDate
            .startWith {
                if case let .edit(_, target) = self.editingType {
                    return (target.graduateYear ?? currentYear, target.graduateMonth ?? currentMonth)
                } else {
                    return (currentYear, currentMonth)
                }
            }

        let educationItem = Driver.combineLatest(
            title,
            description,
            entranceDate.map { "\($0.year).\($0.month.toLeadingZero(digit: 2))" },
            graduateDate.map { "\($0.year).\($0.month.toLeadingZero(digit: 2))" },
            schoolEnrollmentStatus
        ) { title, description, entranceDateString, graduateDateString, enrollmentStatus in
            let period: String
            switch enrollmentStatus {
            case .enrolled:
                period = "\(entranceDateString) - \(SchoolEnrollmentStatus.enrolled.rawValue)"
            case .graduated:
                period = "\(entranceDateString) - \(graduateDateString)"
            }
            return Education(period: period,
                                 title: title,
                                 description: description)
        }

        let doneHandler = input.doneTrigger
            .withLatestFrom(educationItem)
            .doOnNext(endEditing(with:))
            .mapToVoid()

        let deleteHandler = input.deleteTrigger
            .doOnNext {
                if case let .edit(index, _) = self.editingType {
                    self.delegate?.educationEditingViewModelDidDeleteEducationItem(at: index)
                }
            }

        return .init(
            title: title,
            description: description,
            entranceDate: entranceDate,
            graduateDate: graduateDate,
            doneHandler: doneHandler,
            editingType: editingType,
            deleteHandler: deleteHandler,
            schoolEnrollmentStatus: schoolEnrollmentStatus
        )
    }

    private func endEditing(with educationItem: Education) {
        switch editingType {
        case .edit(let index, _):
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
        let deleteTrigger: Signal<Void>
        let selectedEnrollmentStatus: Driver<SchoolEnrollmentStatus>
    }

    struct Output {
        let title: Driver<String>
        let description: Driver<String>
        let entranceDate: Driver<(year: Int, month: Int)>
        let graduateDate: Driver<(year: Int, month: Int)>
        let doneHandler: Signal<Void>
        let editingType: Driver<EditingType>
        let deleteHandler: Signal<Void>
        let schoolEnrollmentStatus: Driver<SchoolEnrollmentStatus>
    }
}

// MARK: - EditingType

extension EducationEditingViewModel {

    enum EditingType {

        /// 기존 학력 정보를 수정할 때 사용하는 열거형 값입니다.
        case edit(index: IndexPath.Index, target: Education)

        /// 새 학력 정보를 추가할 때 사용하는 열거형 값입니다.
        case new
    }
}
