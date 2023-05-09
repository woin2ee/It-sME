//
//  TotalCVViewModel.swift
//  ItsME
//
//  Created by MacBook Air on 2023/01/03.
//

import RxSwift
import RxCocoa
import FirebaseStorage

final class TotalCVViewModel: ViewModelType {
    
    private let userRepository: UserProfileRepository = .shared
    private let cvRepository: CVRepository = .shared
    
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
                return self.userRepository.getUserProfile()
                    .asDriver(onErrorDriveWith: .empty())
            }
        
        let cvInfoDriver = cvInfoRelay.asDriver()
        
        let userInfoItems = userInfo.map { $0.defaultItems + $0.otherItems }
        
        let educationItems = userInfo.map { $0.educationItems }
        
        let profileImageData = userInfo.flatMap {
            Storage.storage().reference().child($0.profileImageURL).rx.getData().map { $0 }
                .asDriverOnErrorJustComplete()
        }
        
        let tappedEditingCompleteButton = input.doneTrigger
            .withLatestFrom(cvInfoDriver)
            .flatMapFirst { cvInfo in
                return self.cvRepository.saveCVInfo(cvInfo)
                    .asSignalOnErrorJustComplete() // TODO: Error 처리 고려
            }
        
        return .init(
            userInfoItems: userInfoItems,
            educationItems: educationItems,
            profileImageData: profileImageData,
            cvInfo: cvInfoDriver,
            tappedEditCompleteButton: tappedEditingCompleteButton
        )
    }
}

// MARK: - Methods

extension TotalCVViewModel {
    
    func removeResumeCategory(indexPath: IndexPath, resumeCatgory: ResumeCategory) {
        let changedCVInfo = cvInfoRelay.value
        changedCVInfo.resume.category.remove(at: indexPath.section)
    }
}

// MARK: - Input & Output

extension TotalCVViewModel {
    
    struct Input {
        let viewDidLoad: Signal<Void>
        let doneTrigger: Signal<Void>
    }
    
    struct Output {
        let userInfoItems: Driver<[UserBasicProfileInfo]>
        let educationItems: Driver<[Education]>
        let profileImageData: Driver<Data>
        let cvInfo: Driver<CVInfo>
        let tappedEditCompleteButton: Signal<Void>
    }
}

// MARK: - CoverLetterEditingViewModelDelegate

extension TotalCVViewModel: CoverLetterEditingViewModelDelegate {
    
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

// MARK: - CategoryEditingViewModelDelegate

extension TotalCVViewModel: CategoryEditingViewModelDelegate {
    
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
    
    func categoryEditingViewModelDidRemove(at section: Int) {
        let changedCVInfo = cvInfoRelay.value
        changedCVInfo.resume.category.remove(at: section)
        cvInfoRelay.accept(changedCVInfo)
    }
}

// MARK: - ResumeItemEditingViewModelDelegate

extension TotalCVViewModel: ResumeItemEditingViewModelDelegate {
    
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
}
