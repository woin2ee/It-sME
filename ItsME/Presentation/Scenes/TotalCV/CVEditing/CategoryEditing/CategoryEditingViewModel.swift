//
//  CategoryEditingViewModel.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/07.
//

import RxSwift
import RxCocoa

final class CategoryEditingViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Signal<Void>
        let entranceDate: Driver<(year: Int, month: Int)>
        let endDate: Driver<(year: Int, month: Int)>
    }
    
    struct Output {
        let resumeItem: Driver<ResumeItem>
        
    }
    
    let behaviorRelay: BehaviorRelay<ResumeItem>
    
    var item: ResumeItem {
        behaviorRelay.value
    }
    
    init(resumeItem: ResumeItem) {
        self.behaviorRelay = .init(value: resumeItem)
    }
    
    func transform(input: Input) -> Output {
        let resumeItem = behaviorRelay.asDriver()
        return .init(resumeItem: resumeItem)
    }
}
