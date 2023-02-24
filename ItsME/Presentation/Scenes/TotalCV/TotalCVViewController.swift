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
    let headerFont: UIFont = .systemFont(ofSize: 30, weight: .bold)
    private var isEditingMode: Bool = false
    let navigationBarHeight = 91
    
    private var fullScrollView: UIScrollView = .init().then {
        $0.backgroundColor = .systemBackground
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private var contentView: UIView = .init().then {
        $0.backgroundColor = .clear
    }
    
    private var justCVView: UIView = .init().then {
        $0.backgroundColor = .clear
    }
    
    private var bothView: UIView = .init().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var profileImageView =  UIImageView().then {
        $0.image = .init(named: "테스트이미지")
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var totalUserInfoItemStackView: TotalUserInfoItemStackView = .init()
    
    private lazy var educationHeaderLabel: UILabel = .init().then {
        $0.text = "학력"
        $0.font = headerFont
        $0.textColor = .systemBlue
    }
    
    private lazy var educationTableView: IntrinsicHeightTableView = .init().then {
        $0.delegate = self
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.isUserInteractionEnabled = false
        $0.sectionHeaderHeight = 0
        $0.backgroundColor = .clear
        let cellType = EducationCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    private lazy var categoryTableView: IntrinsicHeightTableView = .init().then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.isUserInteractionEnabled = false
        let cellType = CategoryCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        let sectionType = CategoryHeaderView.self
        $0.register(sectionType, forHeaderFooterViewReuseIdentifier: sectionType.reuseIdentifier)
        $0.sectionHeaderHeight = 45
    }
    
    private lazy var coverLetterLabel: UILabel = .init().then {
        $0.text = "자기소개서"
        $0.font = headerFont
        $0.textColor = .systemBlue
    }
    
    private lazy var coverLetterTableView: IntrinsicHeightTableView = .init().then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.isUserInteractionEnabled = false
        let cellType = CoverLetterCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        let sectionType = CoverLetterHeaderView.self
        $0.register(sectionType, forHeaderFooterViewReuseIdentifier: sectionType.reuseIdentifier)
        $0.sectionHeaderHeight = 25
    }
    
    private lazy var editModeButton: UIBarButtonItem = .init().then {
        $0.primaryAction = UIAction(image: UIImage(systemName: "wrench.and.screwdriver.fill"), handler: { _ in
            self.isEditingMode.toggle()
            self.changeButton()
            self.changeMode()
        })
    }
    
    func changeButton() {
        if isEditingMode {
            self.editModeButton.image = nil
            self.editModeButton.title = "수정 완료"
        } else {
            self.editModeButton.image = UIImage(systemName: "wrench.and.screwdriver.fill")
        }
    }
    
    func changeMode() {
        if isEditingMode {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.bothView.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                }
                
                self.justCVView.alpha = 0
                self.fullScrollView.backgroundColor = .secondarySystemBackground
                self.fullScrollView.setContentOffset(CGPoint(x: 0, y: -self.navigationBarHeight), animated: true)
                self.categoryTableView.setEditing(true, animated: true)
                self.coverLetterTableView.setEditing(true, animated: true)
                
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.justCVView.removeFromSuperview()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.bothView.removeFromSuperview()
                self.configureSubviews()
                self.justCVView.alpha = 1
                self.fullScrollView.backgroundColor = .systemBackground
                self.fullScrollView.setContentOffset(CGPoint(x: 0, y: -self.navigationBarHeight), animated: true)
                self.categoryTableView.setEditing(false, animated: true)
                self.coverLetterTableView.setEditing(false, animated: true)
                
                self.view.layoutIfNeeded()
            })
        }
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
        self.navigationItem.rightBarButtonItem = editModeButton
        //FIXME: - 화면을 끝까지 내렸을 때 자동으로 Large title로 변경되는 오류를 해결해줘야 함
        //        navigationController?.navigationBar.prefersLargeTitles = true
        //        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        
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
        
        self.contentView.addSubview(justCVView)
        justCVView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        self.contentView.addSubview(bothView)
        bothView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(justCVView.snp.bottom).offset(10)
        }
        
        self.justCVView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(self.view.frame.width * 0.35)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.justCVView.addSubview(totalUserInfoItemStackView)
        totalUserInfoItemStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalTo(profileImageView.snp.leading).offset(-10)
            make.leading.equalToSuperview().offset(10)
        }
        
        self.justCVView.addSubview(educationHeaderLabel)
        educationHeaderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(totalUserInfoItemStackView.snp.bottom).offset(30)
        }
        
        self.justCVView.addSubview(educationTableView)
        educationTableView.snp.makeConstraints { make in
            make.top.equalTo(educationHeaderLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.bothView.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        self.bothView.addSubview(coverLetterLabel)
        coverLetterLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(categoryTableView.snp.bottom).offset(30)
        }
        
        self.bothView.addSubview(coverLetterTableView)
        coverLetterTableView.snp.makeConstraints { make in
            make.top.equalTo(coverLetterLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
    }
}

// MARK: - UITableViewDelegate
extension TotalCVViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == categoryTableView {
            return viewModel.resumeCategory[section].items.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == categoryTableView {
            return viewModel.resumeCategory.count
        } else {
            return viewModel.coverLetterItems.count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == categoryTableView {
            let categoryView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoryHeaderView.reuseIdentifier) as? CategoryHeaderView
            categoryView?.titleLabel.text = viewModel.resumeCategory[section].title
            categoryView?.backgroundColor = .clear
            return categoryView
        } else {
            let coverLetterView = tableView.dequeueReusableHeaderFooterView(withIdentifier:CoverLetterHeaderView.reuseIdentifier) as? CoverLetterHeaderView
            coverLetterView?.titleLabel.text = viewModel.coverLetterItems[ifExists: section]?.title
            coverLetterView?.backgroundColor = .clear
            return coverLetterView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let resumeCategory = viewModel.resumeCategory
        
        if tableView == categoryTableView {
            guard let categoryCell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
                return UITableViewCell()
            }
            categoryCell.bind(resumeItem: resumeCategory[indexPath.section].items[indexPath.row])
            
            return categoryCell
            
        } else {
            guard let coverLetterCell = tableView.dequeueReusableCell(withIdentifier: CoverLetterCell.reuseIdentifier, for: indexPath) as? CoverLetterCell else {
                return UITableViewCell()
            }
            coverLetterCell.contents.text = viewModel.coverLetterItems[ifExists: indexPath.section]?.contents
            
            return coverLetterCell
        }
    }
}
