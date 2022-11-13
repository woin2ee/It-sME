//
//  HomeViewController.swift
//  It'sME
//
//  Created by MacBook Air on 2022/11/07.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    
    private var disposeBag: DisposeBag = .init()
    
    private let viewModel: HomeViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
    }
}

// MARK: - Private functions

private extension HomeViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .white
    }
    
    func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = HomeViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .drive(onNext: { userInfo in
                // input 에 대한 output 으로 userInfo 를 받았을 때 수행할 작업 정의
                print(userInfo)
            })
            .disposed(by: disposeBag)
    }
}
