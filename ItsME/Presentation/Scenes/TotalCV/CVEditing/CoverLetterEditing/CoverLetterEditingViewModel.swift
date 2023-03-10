//
//  CoverLetterEditingViewModel.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/09.
//

import RxCocoa
import RxSwift

final class CoverLetterEditingViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Signal<Void>
    }
    
    struct Output {
        let coverLetterItem: Driver<CoverLetterItem>
        
    }
    
    let behaviorRelay: BehaviorRelay<CoverLetterItem>
    
    var totalCVViewModel: TotalCVViewModel
    
    var coverLetterItem: CoverLetterItem {
        behaviorRelay.value
    }
    
    init(coverLetter: CoverLetterItem?, totalCVVM: TotalCVViewModel) {
        self.behaviorRelay = .init(value: coverLetter ?? CoverLetterItem(title: "", contents: ""))
        self.totalCVViewModel = totalCVVM
    }
    
    func transform(input: Input) -> Output {
        let coverLetter = behaviorRelay.asDriver()
        return .init(coverLetterItem: coverLetter)
    }
}

