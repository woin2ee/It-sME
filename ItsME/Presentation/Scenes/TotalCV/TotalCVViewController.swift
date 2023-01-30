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
    
    var viewModel: TotalCVViewModel!
    
    private var fullScrollView: UIScrollView = .init().then {
        $0.backgroundColor = .systemBackground
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private var contentView: UIView = .init().then {
        $0.backgroundColor = .systemBackground
    }
    
    private lazy var profileImageView =  UIImageView().then {
        $0.image = .init(named: "테스트이미지")
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var totalUserInfoItemStackView: TotalUserInfoItemStackView = .init()
    
    private lazy var educationHeaderLabel: UILabel = .init().then {
        $0.text = "학력"
        $0.font = .boldSystemFont(ofSize: 26)
        $0.textColor = .systemBlue
    }
    
    private lazy var educationTableView: IntrinsicHeightTableView = .init().then {
        $0.delegate = self
        $0.backgroundColor = .systemBackground
        $0.isScrollEnabled = false
        $0.separatorInset = .zero
        $0.isUserInteractionEnabled = false
        let cellType = EducationCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
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
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.circular()
    }
    // MARK: - Navigation
    
    func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        
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
            .drive(
                educationTableView.rx.items(cellIdentifier: EducationCell.reuseIdentifier, cellType: EducationCell.self)
            ) { (index, educationItem, cell) in
                cell.bind(educationItem: educationItem)
            }
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
        return .init(self) { viewController, userInfoItems in
            self.totalUserInfoItemStackView.bind(userInfoItems: userInfoItems)
        }
    }
    
    var educationBinding: Binder<[EducationItem]> {
        return .init(self) { viewController, education in
            
        }
    }
    
    var cvsInfoBinding: Binder<CVInfo> {
        return .init(self) { viewController, cvInfo in
            self.navigationItem.title = cvInfo.title
            
        }
    }
}

private extension TotalCVViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureSubviews() {
        
        self.view.addSubview(fullScrollView)
        fullScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.fullScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.width.equalToSuperview()
        }
        
        self.contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(self.view.frame.width * 0.35)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.contentView.addSubview(totalUserInfoItemStackView)
        totalUserInfoItemStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalTo(profileImageView.snp.leading).offset(-10)
            make.leading.equalToSuperview().offset(10)
        }
        
        self.contentView.addSubview(educationHeaderLabel)
        educationHeaderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(totalUserInfoItemStackView.snp.bottom).offset(30)
        }
        
        self.contentView.addSubview(educationTableView)
        educationTableView.snp.makeConstraints { make in
            make.top.equalTo(educationHeaderLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(24)
        }
        
        self.contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(totalUserInfoItemStackView.snp.bottom).offset(1200)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate
extension TotalCVViewController: UITableViewDelegate {
    
}




