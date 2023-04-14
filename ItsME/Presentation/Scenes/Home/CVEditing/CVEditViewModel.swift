//
//  CVEditViewModel.swift
//  ItsME
//
//  Created by MacBook Air on 2023/04/04.
//

import RxSwift
import RxCocoa

final class CVEditViewModel: ViewModelType {
    
    //MARK: - Input & Output
    struct Input {
        let cvTitle: Driver<String>
        let doneTrigger: Signal<Void>
    }
    
    struct Output {
        let cvTitle: Driver<String>
        let doneHandler: Signal<Void>
        let editingType: Driver<EditingType>
    }
    private let cvRepository: CVRepository = CVRepository.shared
    
    let cvTitle: String
    let editingType: EditingType
    
    init(
        cvTitle: String,
        editingType: EditingType
    ) {
        self.cvTitle = cvTitle
        self.editingType = editingType
    }
    
    //MARK: - transform
    func transform(input: Input) -> Output {
        let cvTitle = input.cvTitle
            .startWith(cvTitle)
        
        let doneHandler = input.doneTrigger
            .withLatestFrom(cvTitle)
            .flatMap { cvTitle -> Signal<Void> in
                self.endEditing(with: cvTitle)
            }
            .mapToVoid()
        
        let editingType = Driver.just(editingType)
        
        return .init(
            cvTitle: cvTitle,
            doneHandler: doneHandler,
            editingType: editingType
        )
    }
    
    private func endEditing(with cvTitle: String) -> Signal<Void> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let todayString = dateFormatter.string(from: Date())
        
        switch editingType {
        case .edit(let uuid):
            return cvRepository.saveCurrentCVTitle(cvTitle, lastModified: todayString, uuid: uuid).asSignalOnErrorJustComplete()
        case .new:
            let cvInfo: CVInfo = .init(title: cvTitle, resume: Resume.empty, coverLetter: CoverLetter.empty, lastModified: todayString)
            return cvRepository.saveCurrentCVInfo(cvInfo).asSignalOnErrorJustComplete()
        }
    }
}

//MARK: - EditingType
extension CVEditViewModel {
    
    enum EditingType {
        
        /// 기존 CV 정보를 수정할 때 사용하는 열거형 값입니다.
        case edit(uuid: String)
        
        /// 새 CV를 추가할 때 사용하는 열거형 값입니다.
        case new
    }
}
