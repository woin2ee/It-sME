//
//  CategoryEditingViewModel.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/22.
//

import RxSwift
import RxCocoa

protocol CategoryEditingViewModelDelegate: AnyObject {
    func categoryEditingViewModelDidEndEditing(with title: String, at section: Int)
    func categoryEditingViewModelDidAppend(title: String)
    func categoryEditingViewModelDidRemove(at section: Int)
}

final class CategoryEditingViewModel: ViewModelType {

    let categoryTitle: String
    let editingType: EditingType
    private weak var delegate: CategoryEditingViewModelDelegate?

    init(
        categoryTitle: String,
        editingType: EditingType,
        delegate: CategoryEditingViewModelDelegate? = nil
    ) {
        self.categoryTitle = categoryTitle
        self.editingType = editingType
        self.delegate = delegate
    }

    func transform(input: Input) -> Output {

        let title = input.title
            .startWith(categoryTitle)

        let doneHandler = input.doneTrigger
            .withLatestFrom(title)
            .do(onNext: endEditing(with:))
            .mapToVoid()

        let editingType = Driver.just(editingType)

        let removeHandler = input.removeTrigger
                .do(onNext: { _ in
                    if case let .edit(section) = self.editingType {
                        self.delegate?.categoryEditingViewModelDidRemove(at: section)
                    }
                })

        return .init(
            title: title,
            doneHandler: doneHandler,
            removeHandler: removeHandler,
            editingType: editingType
        )
    }

    private func endEditing(with title: String) {
        switch editingType {
        case .edit(let section):
            delegate?.categoryEditingViewModelDidEndEditing(with: title, at: section)
        case .new:
            delegate?.categoryEditingViewModelDidAppend(title: title)
        }
    }
}

extension CategoryEditingViewModel {

    struct Input {
        let title: Driver<String>
        let doneTrigger: Signal<Void>
        let removeTrigger: Signal<Void>
    }

    struct Output {
        let title: Driver<String>
        let doneHandler: Signal<Void>
        let removeHandler: Signal<Void>
        let editingType: Driver<EditingType>
    }
}

// MARK: - EditingType
extension CategoryEditingViewModel {

    enum EditingType {

        /// 기존 카테고리 정보를 수정할 때 사용하는 열거형 값입니다.
        case edit(section: Int)

        /// 새 카테고리를 추가할 때 사용하는 열거형 값입니다.
        case new
    }
}
