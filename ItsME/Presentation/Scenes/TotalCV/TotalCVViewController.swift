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
    let editModeInset = 15
    let commonOffset = 15
    let addButtonSize = 120
    
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
    
    private var categoryEditingBackgroundView: UIView = .init().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private var coverLetterEditingBackgroundView: UIView = .init().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
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
        $0.allowsSelectionDuringEditing = true
        let cellType = CategoryCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        let sectionType = CategoryHeaderView.self
        $0.register(sectionType, forHeaderFooterViewReuseIdentifier: sectionType.reuseIdentifier)
        $0.sectionHeaderHeight = 45
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
        $0.sectionHeaderHeight = 45
    }
    
    private lazy var editModeButton: UIBarButtonItem = .init().then {
        $0.primaryAction = UIAction(image: UIImage(systemName: "wrench.and.screwdriver.fill"), handler: { _ in
            self.isEditingMode.toggle()
            self.changeButton()
            self.changeMode()
        })
        $0.style = .done
    }
    
    private lazy var backButton: UIBarButtonItem = .init(systemItem: .cancel).then {
        $0.primaryAction = .init(handler: { [weak self] _ in
            let title = "정말로 뒤로 가시겠습니까?"
            let message = "소중한 회원님의 정보는 되돌릴 수 없습니다. 이 사실을 인지하고 뒤로 가시겠습니까?"
            let alertVC = CommonAlertViewController(title: title, message: message, style: .confirm, okHandler: {
                self?.navigationController?.popViewController(animated: true)
            })
            self?.present(alertVC, animated: true)
        })
    }
    
    private lazy var categoryAddButton: EditModeAddButton = .init().then {
        var config = UIButton.Configuration.filled()
        let title: NSAttributedString = .init(string: "카테고리를 더 추가하시겠습니까?", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .heavy)])
        $0.setAttributedTitle(title, for: .normal)
        config.titleAlignment = .center
        config.background.backgroundColor = .clear
        config.baseForegroundColor = .mainColor
        config.image = UIImage(systemName: "plus.rectangle.fill", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 30, weight: .heavy, scale: .large))
        config.imagePlacement = .bottom
        config.imagePadding = 10
        $0.setBackgroundColor(.systemBackground, for: .normal)
        $0.setBackgroundColor(.systemGray4, for: .highlighted)
        
        $0.configuration = config
        
        let action: UIAction = .init(handler: { [weak self] _ in
            print("PRESS categoryAddButton!!!!")
            
            //            let viewModel: CategoryEditingViewModel = .init(resumeItem:)
            //            let viewController: CategoryEditingViewController = .init(viewModel: viewModel)
            //            self?.navigationController?.pushViewController(viewController, animated: true)
        })
        $0.addAction(action, for: .touchUpInside)
    }
    
    private lazy var coverLetterAddButton: EditModeAddButton = .init().then {
        var config = UIButton.Configuration.filled()
        let title: NSAttributedString = .init(string: "항목을 더 추가하시겠습니까?", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .heavy)])
        $0.setAttributedTitle(title, for: .normal)
        config.titleAlignment = .center
        config.background.backgroundColor = .systemBackground
        config.baseForegroundColor = .mainColor
        config.image = UIImage(systemName: "plus.rectangle.fill", withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 30, weight: .heavy, scale: .large))
        config.imagePlacement = .bottom
        config.imagePadding = 10
        $0.setBackgroundColor(.systemGray4, for: .normal)
        $0.setBackgroundColor(.systemBackground, for: .highlighted)
        
        $0.configuration = config
        let action: UIAction = .init(handler: { [weak self] _ in
            print("PRESS coverLetterAddButton!!!!")
        })
        $0.addAction(action, for: .touchUpInside)
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
                self.categoryTableView.snp.removeConstraints()
                self.coverLetterTableView.snp.removeConstraints()
                
                self.categoryTableView.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.leading.trailing.equalToSuperview().inset(self.editModeInset)
                }
                
                self.coverLetterTableView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(self.commonOffset)
                    make.leading.trailing.equalToSuperview().inset(self.editModeInset)
                }
                
                self.categoryEditingBackgroundView.addSubview(self.categoryAddButton)
                self.categoryAddButton.snp.makeConstraints { make in
                    make.top.equalTo(self.categoryTableView.snp.bottom).offset(self.commonOffset)
                    make.height.equalTo(self.addButtonSize)
                    make.leading.trailing.equalToSuperview().inset(self.editModeInset)
                    make.bottom.equalToSuperview().offset(-self.commonOffset)
                }
                
                self.coverLetterEditingBackgroundView.addSubview(self.coverLetterAddButton)
                self.coverLetterAddButton.snp.makeConstraints{ make in
                    make.top.equalTo(self.coverLetterTableView.snp.bottom).offset(self.commonOffset)
                    make.height.equalTo(self.addButtonSize)
                    make.bottom.equalToSuperview().offset(-self.commonOffset)
                    make.leading.trailing.equalToSuperview().inset(self.editModeInset)
                }
                
                self.justCVView.alpha = 0
                self.categoryEditingBackgroundView.backgroundColor = .systemGray5
                self.categoryTableView.setEditing(true, animated: true)
                self.categoryTableView.isUserInteractionEnabled = true
                
                self.coverLetterEditingBackgroundView.backgroundColor = .systemGray5
                self.coverLetterTableView.setEditing(true, animated: true)
                self.coverLetterTableView.isUserInteractionEnabled = true
                
                self.fullScrollView.backgroundColor = .secondarySystemBackground
                self.fullScrollView.setContentOffset(CGPoint(x: 0, y: -self.navigationBarHeight), animated: true)
                
                self.view.layoutIfNeeded()
                self.navigationItem.leftBarButtonItem = self.backButton
                self.justCVView.removeFromSuperview()
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                
                self.categoryEditingBackgroundView.backgroundColor = .clear
                self.categoryAddButton.removeFromSuperview()
                self.categoryTableView.setEditing(false, animated: true)
                self.categoryTableView.isUserInteractionEnabled = false
                self.categoryTableView.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().offset(self.commonOffset)
                }
                
                self.coverLetterEditingBackgroundView.backgroundColor = .clear
                self.coverLetterAddButton.removeFromSuperview()
                self.coverLetterTableView.setEditing(false, animated: true)
                self.coverLetterTableView.isUserInteractionEnabled = false
                self.coverLetterTableView.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().offset(self.commonOffset)
                }
                
                self.bothView.removeFromSuperview()
                self.configureSubviews()
                self.justCVView.alpha = 1
                
                self.fullScrollView.backgroundColor = .systemBackground
                self.fullScrollView.setContentOffset(CGPoint(x: 0, y: -self.navigationBarHeight), animated: true)
                
                self.navigationItem.leftBarButtonItem = nil
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
            make.top.equalTo(educationHeaderLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        self.bothView.addSubview(categoryEditingBackgroundView)
        categoryEditingBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(commonOffset)
            make.leading.trailing.equalToSuperview().inset(editModeInset)
        }
        
        self.categoryEditingBackgroundView.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(editModeInset)
            make.bottom.equalToSuperview().offset(-commonOffset)
        }
        
        self.bothView.addSubview(coverLetterEditingBackgroundView)
        coverLetterEditingBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(categoryEditingBackgroundView.snp.bottom).offset(commonOffset)
            make.leading.trailing.equalToSuperview().inset(editModeInset)
            make.bottom.equalToSuperview()
        }
        
        self.coverLetterEditingBackgroundView.addSubview(coverLetterTableView)
        coverLetterTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(commonOffset)
            make.leading.trailing.equalToSuperview().inset(editModeInset)
            make.bottom.equalToSuperview().offset(-commonOffset)
        }
    }
    
    func pushCategoryEditingView(indexPath: IndexPath) {
        let CategoryEditingviewModel: CategoryEditingViewModel = .init(resumeItem: self.viewModel.resumeCategory[ifExists: indexPath.section]!.items[indexPath.row])
        
        let viewController: CategoryEditingViewController = .init(viewModel: CategoryEditingviewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushCoverLetterEditingView() {
        //        let viewController: CategoryEditingViewController = .init(viewModel: viewModel)
        //        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //        func presentCategoryItemEditingView(by indexPath: IndexPath) {
    //            coverLetterEditingView()
    //        }
}

// MARK: - UITableViewDelegate
extension TotalCVViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == categoryTableView {
            return viewModel.resumeCategory[section].items.count
        } else {
            return viewModel.coverLetter.items.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == categoryTableView {
            return viewModel.resumeCategory.count
        } else {
            return 1
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
            coverLetterView?.backgroundColor = .clear
            return coverLetterView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let resumeCategory = viewModel.resumeCategory
        let coverLetter = viewModel.coverLetter
        
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
            coverLetterCell.bind(coverLetterItem: coverLetter.items[indexPath.row])
            
            return coverLetterCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == categoryTableView {
            pushCategoryEditingView(indexPath: indexPath)
            print("ASDASDASDASDASDASD")
        } else {
            pushCoverLetterEditingView()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let resumeCategory = viewModel.resumeCategory
        let coverLetter = viewModel.coverLetter
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if tableView == categoryTableView {
                print("categoryTableView delete")
                resumeCategory[indexPath.section].items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if tableView == coverLetterTableView {
                print("coverLetterTableView delete")
                coverLetter.items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } else if editingStyle == UITableViewCell.EditingStyle.insert {
            if tableView == categoryTableView {
                print("categoryTableView insert")
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
            if tableView == coverLetterTableView {
                print("coverLetterTableView insert")
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if tableView == categoryTableView {
            if sourceIndexPath.section != proposedDestinationIndexPath.section {
                return sourceIndexPath
            } else {
                return proposedDestinationIndexPath
            }
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let resumeCategory = viewModel.resumeCategory
        let coverLetter = viewModel.coverLetter
        
        if tableView == categoryTableView {
            print("\(resumeCategory[sourceIndexPath.section].items) from: \(sourceIndexPath.row) -> to: \(destinationIndexPath.row)")
            let targetItem = resumeCategory[sourceIndexPath.section].items[sourceIndexPath.row]
            resumeCategory[sourceIndexPath.section].items.remove(at: sourceIndexPath.row)
            resumeCategory[destinationIndexPath.section].items.insert(targetItem, at: destinationIndexPath.row)
        }
        
        if tableView == coverLetterTableView {
            print("\(coverLetter.items) from: \(sourceIndexPath.row) -> to: \(destinationIndexPath.row)")
            let targetItem = coverLetter.items[sourceIndexPath.row]
            coverLetter.items.remove(at: sourceIndexPath.row)
            coverLetter.items.insert(targetItem, at: destinationIndexPath.row)
        }
//FIXME: - 선택한 셀이 섹션이 넘어가지 않게끔, 데이터 처리
    }
}
