//
//  TotalCVViewModel.swift
//  ItsME
//
//  Created by MacBook Air on 2023/01/03.
//

import RxSwift
import RxCocoa

final class TotalCVViewModel: ViewModelType {
    
    private let userRepository: UserRepository = .init()
    private let cvRepository: CVRepository = .init()
    
    private let cvInfoRelay: BehaviorRelay<CVInfo>
    
    
    var resumeCategory: [ResumeCategory] {
        cvInfoRelay.value.resume.category
    }
    
    var coverLetter: CoverLetter {
        cvInfoRelay.value.coverLetter
    }
    
    init(cvInfo: CVInfo) {
        self.cvInfoRelay = .init(value: cvInfo)
    }
    
    func transform(input: Input) -> Output {
        let userInfo = input.viewDidLoad
            .flatMapLatest { _ in
                return self.userRepository.getCurrentUserInfo()
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let cvInfo = cvInfoRelay.asDriver()
        let userInfoItems = userInfo.map { $0.defaultItems + $0.otherItems }
        
        let educationItems = userInfo.map { $0.educationItems }
        
        let completeHandler = input.doneTrigger
            .withLatestFrom(cvInfo)
            .do(onNext: { cvInfo in
                // TODO: 유저 정보 저장
                print(cvInfo)
            })
        
        return .init(
            userInfoItems: userInfoItems,
            educationItems: educationItems,
            cvInfo: cvInfo,
            tappedEditCompleteButton: completeHandler
        )
    }
}

// MARK: - International Function
extension TotalCVViewModel {
    func removeResumeCategory(indexPath: IndexPath, resumeCatgory: ResumeCategory) {
        let changedCVInfo = cvInfoRelay.value
        changedCVInfo.resume.category.remove(at: indexPath.section)
    }
}

//MARK: - Input & Output
extension TotalCVViewModel {
    
    struct Input {
        let viewDidLoad: Signal<Void>
        let doneTrigger: Signal<Void>
    }
    
    struct Output {
        let userInfoItems: Driver<[UserInfoItem]>
        let educationItems: Driver<[EducationItem]>
        let cvInfo: Driver<CVInfo>
        let tappedEditCompleteButton: Signal<CVInfo>
    }
}

// MARK: - Extension Delegate
extension TotalCVViewModel:
    CoverLetterEditingViewModelDelegate, CategoryEditingViewModelDelegate, ResumeItemEditingViewModelDelegate {
    
    func resumeItemEditingViewModelDidEndEditing(with resumeItem: ResumeItem, at indexPath: IndexPath) {
        let changedCVInfo = cvInfoRelay.value
        changedCVInfo.resume.category[indexPath.section].items[indexPath.row] = resumeItem
        cvInfoRelay.accept(changedCVInfo)
    }
    
    func resumeItemEditingViewModelDidAppend(with resumeItem: ResumeItem, at section: Int) {
        let changedCVInfo = cvInfoRelay.value
        changedCVInfo.resume.category[section].items.append(resumeItem)
        cvInfoRelay.accept(changedCVInfo)
    }
    
    func categoryEditingViewModelDidEndEditing(with title: String, at section: Int) {
        let changedCVInfo = cvInfoRelay.value
        changedCVInfo.resume.category[section].title = title
        cvInfoRelay.accept(changedCVInfo)
    }
    
    func categoryEditingViewModelDidAppend(title: String) {
        let changedCVInfo = cvInfoRelay.value
        changedCVInfo.resume.category.append(.init(title: title, items: []))
        cvInfoRelay.accept(changedCVInfo)
    }
    
    func coverLetterEditingViewModelDidEndEditing(with coverLetterItem: CoverLetterItem, at indexPath: IndexPath) {
        let changedCVInfo = cvInfoRelay.value
        changedCVInfo.coverLetter.items[indexPath.row] = coverLetterItem
        cvInfoRelay.accept(changedCVInfo)
    }
    
    func coverLetterEditingViewModelDidAppend(coverLetterItem: CoverLetterItem) {
        let changedCVInfo = cvInfoRelay.value
        changedCVInfo.coverLetter.items.append(coverLetterItem)
        cvInfoRelay.accept(changedCVInfo)
    }
}
