//
//  TotalCVViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/01/03.
//

import RxSwift
import SFSafeSymbols
import SnapKit
import UIKit
import Then

class TotalCVViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    let viewModel: TotalCVViewModel
    
    let headerFont: UIFont = .systemFont(ofSize: 30, weight: .bold)
    private var isEditingMode: Bool = false
    let navigationBarHeight = 91
    let editModeInset = 15
    let commonOffset = 15
    let addButtonSize = 120
    
    //MARK: - UI Component
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
    
    private lazy var profileImageView: UIImageView = .init().then {
        $0.image = .defaultProfileImage
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
        $0.allowsSelectionDuringEditing = true
        let cellType = CoverLetterCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        let sectionType = CoverLetterHeaderView.self
        $0.register(sectionType, forHeaderFooterViewReuseIdentifier: sectionType.reuseIdentifier)
        $0.sectionHeaderHeight = 45
    }
    
    private lazy var editModeButton: UIBarButtonItem = .init().then {
        $0.image = UIImage(systemSymbol: .wrenchAndScrewdriverFill)
        $0.style = .done
    }
    
    private lazy var backButton: UIBarButtonItem = .init(systemItem: .cancel).then {
        $0.primaryAction = .init(handler: { [weak self] _ in
            let title = "정말로 뒤로 가시겠습니까?"
            let message = "소중한 회원님의 정보는 되돌릴 수 없습니다. 이 사실을 인지하고 뒤로 가시겠습니까?"
            self?.presentConfirmAlert(
                title: title,
                message: message,
                cancelAction: .init(title: "아니오", style: .cancel),
                okAction: .init(title: "예", style: .default, handler: { _ in
                    self?.navigationController?.popViewController(animated: true)
                })
            )
        })
    }
    
    private lazy var categoryAddButton: EditModeAddButton = .init().then {
        var config = UIButton.Configuration.filled()
        let title: NSAttributedString = .init(string: "카테고리를 더 추가하시겠습니까?", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .heavy)])
        $0.setAttributedTitle(title, for: .normal)
        config.titleAlignment = .center
        config.background.backgroundColor = .clear
        config.baseForegroundColor = .mainColor
        config.image = UIImage(systemSymbol: .plusRectangleFill, withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 30, weight: .heavy, scale: .large))
        config.imagePlacement = .bottom
        config.imagePadding = 10
        $0.setBackgroundColor(.systemBackground, for: .normal)
        $0.setBackgroundColor(.systemGray4, for: .highlighted)
        
        $0.configuration = config
        
        let action: UIAction = .init(handler: { [weak self] _ in
            self?.pushCategoryAddView()
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
        config.image = UIImage(systemSymbol: .plusRectangleFill, withConfiguration: UIImage.SymbolConfiguration.init(pointSize: 30, weight: .heavy, scale: .large))
        config.imagePlacement = .bottom
        config.imagePadding = 10
        $0.setBackgroundColor(.systemGray4, for: .normal)
        $0.setBackgroundColor(.systemBackground, for: .highlighted)
        
        $0.configuration = config
        let action: UIAction = .init(handler: { [weak self] _ in
            self?.pushCoverLetterAddView()
        })
        $0.addAction(action, for: .touchUpInside)
    }
    
    // MARK: - Initializer
    
    init(viewModel: TotalCVViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        
        let input = TotalCVViewModel.Input.init(
            viewDidLoad: .just(()),
            doneTrigger: editModeButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        [
            output.userInfoItems
                .drive(userInfoBinding),
            output.educationItems
                .drive(
                    educationTableView.rx.items(cellIdentifier: EducationCell.reuseIdentifier, cellType: EducationCell.self)
                ) { (index, educationItem, cell) in
                    cell.bind(educationItem: educationItem)
                },
            output.cvInfo
                .drive(cvsInfoBinding),
            output.profileImageData
                .map { imageData -> UIImage in
                    return UIImage(data: imageData) ?? UIImage.defaultProfileImage
                }
                .drive(profileImageView.rx.image),
            output.tappedEditCompleteButton
                .emit(with: self, onNext: { owner, cvInfo in
                    owner.isEditingMode.toggle()
                    
                    for section in 0..<owner.categoryTableView.numberOfSections {
                        guard let headerView = owner.categoryTableView.headerView(forSection: section) as? CategoryHeaderView else {
                            continue
                        }
                        headerView.isEditingMode = self.isEditingMode
                    }
                    owner.changeButton()
                    owner.changeMode()
                })
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
    
    var userInfoBinding: Binder<[UserBasicProfileInfo]> {
        return .init(self) { viewController, userInfoItems in
            self.totalUserInfoItemStackView.bind(userInfoItems: userInfoItems)
        }
    }
    
    var educationBinding: Binder<[Education]> {
        return .init(self) { viewController, education in
            
        }
    }
    
    var cvsInfoBinding: Binder<CVInfo> {
        return .init(self) { vc, cvInfo in
            vc.navigationItem.title = cvInfo.title
            vc.categoryTableView.reloadData()
            vc.coverLetterTableView.reloadData()
            
        }
    }
}


//MARK: - Private Function
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
            make.leading.trailing.equalToSuperview().inset(30)
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
    
    func changeButton() {
        if isEditingMode {
            self.editModeButton.image = nil
            self.editModeButton.title = "수정 완료"
        } else {
            self.editModeButton.image = UIImage(systemSymbol: .wrenchAndScrewdriverFill)
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
    
    func pushResumeItemEditingView(indexPath: IndexPath) {
        
        guard let resumeItem = self.viewModel.resumeCategory[ifExists: indexPath.section]?.items[indexPath.row] else { return }
        
        let resumeItemEditingViewModel: ResumeItemEditingViewModel = .init(resumeItem: resumeItem, editingType: .edit(indexPath: indexPath), delegate: viewModel)
        
        let viewController: ResumeItemEditingViewController = .init(viewModel: resumeItemEditingViewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushResumItemAddView(section: Int) {
        let resumeItem = ResumeItem.empty
        let resumeItemEditingViewModel: ResumeItemEditingViewModel = .init(resumeItem: resumeItem, editingType: .new(section: section), delegate: viewModel)
        let viewController: ResumeItemEditingViewController = .init(viewModel: resumeItemEditingViewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushCategoryEditingView(section: Int) {
        guard let categoryTitle = self.viewModel.resumeCategory[ifExists: section]?.title else { return }
        
        let categoryAddingViewModel: CategoryEditingViewModel = .init(categoryTitle: categoryTitle, editingType: .edit(section: section), delegate: viewModel)
        let viewController: CategoryEditingViewController = .init(viewModel: categoryAddingViewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushCategoryAddView() {
        let categoryAddingViewModel: CategoryEditingViewModel = .init(categoryTitle: "", editingType: .new, delegate: viewModel)
        let viewController: CategoryEditingViewController = .init(viewModel: categoryAddingViewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushCoverLetterEditingView(indexPath: IndexPath) {
        
        guard let coverLetterItem = self.viewModel.coverLetter.items[ifExists: indexPath.row] else { return }
        
        let coverLetterEditingViewModel: CoverLetterEditingViewModel = .init(coverLetterItem: coverLetterItem, editingType: .edit(indexPath: indexPath), delegate: viewModel)
        
        let viewController: CoverLetterEditingViewController = .init(viewModel: coverLetterEditingViewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushCoverLetterAddView() {
        let coverLetterItem = CoverLetterItem.empty
        let coverLetterEditingViewModel: CoverLetterEditingViewModel = .init(coverLetterItem: coverLetterItem, editingType: .new, delegate: viewModel)
        let viewController: CoverLetterEditingViewController = .init(viewModel: coverLetterEditingViewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func makeResumeItemAction(section: Int) -> UIAction {
        return UIAction(
            identifier: UIAction.Identifier("resumeItemIdentifier"),
            handler: { [weak self] action in
                self?.pushResumItemAddView(section: section)
            })
    }
    
    func makeResumeCategoryAction(section: Int) -> UIAction {
        return UIAction(identifier: UIAction.Identifier("resumeCategoryIdentifier"),
                        handler: { [weak self] action in
            self?.pushCategoryEditingView(section: section)
        })
    }
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
            categoryView?.backgroundColor = .clear
            
            categoryView?.titleButton.setTitle(viewModel.resumeCategory[section].title, for: .normal)
            categoryView?.titleButton.addAction(makeResumeCategoryAction(section: section), for: .touchUpInside)
            
            categoryView?.addButton.addAction(UIAction(
                identifier: UIAction.Identifier("resumeItemIdentifier"),
                handler: { [weak self] action in
                    self?.pushResumItemAddView(section: section)
                }), for: .touchUpInside)
            
            categoryView?.isEditingMode = self.isEditingMode
            
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
            categoryCell.selectionStyle = .none
            return categoryCell
            
        } else {
            guard let coverLetterCell = tableView.dequeueReusableCell(withIdentifier: CoverLetterCell.reuseIdentifier, for: indexPath) as? CoverLetterCell else {
                return UITableViewCell()
            }
            coverLetterCell.bind(coverLetterItem: coverLetter.items[indexPath.row])
            coverLetterCell.selectionStyle = .none
            return coverLetterCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == categoryTableView {
            pushResumeItemEditingView(indexPath: indexPath)
        } else {
            pushCoverLetterEditingView(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let resumeCategory = viewModel.resumeCategory
        let coverLetter = viewModel.coverLetter
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if tableView == categoryTableView {
                resumeCategory[indexPath.section].items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if tableView == coverLetterTableView {
                coverLetter.items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
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
            let targetItem = resumeCategory[sourceIndexPath.section].items[sourceIndexPath.row]
            resumeCategory[sourceIndexPath.section].items.remove(at: sourceIndexPath.row)
            resumeCategory[destinationIndexPath.section].items.insert(targetItem, at: destinationIndexPath.row)
        }
        
        if tableView == coverLetterTableView {
            let targetItem = coverLetter.items[sourceIndexPath.row]
            coverLetter.items.remove(at: sourceIndexPath.row)
            coverLetter.items.insert(targetItem, at: destinationIndexPath.row)
        }
    }
}
