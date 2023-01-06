//
//  TotalCVViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/01/03.
//

import RxSwift
import SnapKit
import UIKit
import Then

class TotalCVViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    
    private let viewModel: TotalCVViewModel = .init()
    
    let label = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .systemBlue
        $0.text = "Hello, World!"
    }
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        configureSubviews()
        self.view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    // MARK: - Navigation
    
    func configureNavigationBar() {
        self.navigationItem.title = "asdasdasd"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
// MARK: - Binding ViewModel

private extension TotalCVViewController {
    
    func bindViewModel() {
        let input = makeInput()
        let output = viewModel.transform(input: input)
        
        output.userInfoItems
            .drive(userInfoBinding)
            .disposed(by: disposeBag)
        
        output.educationItems
            .drive(educationBinding)
            .disposed(by: disposeBag)
        
        output.cvInfo
            .drive(cvsInfoBinding)
            .disposed(by: disposeBag)
    }
    
    func makeInput() -> TotalCVViewModel.Input {
        let viewDidLoad = Observable.just(())
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        return .init(viewDidLoad: viewDidLoad)
    }
    
    var userInfoBinding: Binder<[UserInfoItem]> {
        return .init(self) { viewController, userInfo in
            
        }
    }
    
    var educationBinding: Binder<[EducationItem]> {
        return .init(self) { viewController, education in
            
        }
    }
    
    var cvsInfoBinding: Binder<CVInfo> {
        return .init(self) { viewController, cvInfo in
            
        }
    }
}

private extension TotalCVViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureSubviews() {
        self.view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.centerY.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}


