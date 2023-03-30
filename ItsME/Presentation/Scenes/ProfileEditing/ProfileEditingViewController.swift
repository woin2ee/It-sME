//
//  ProfileEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/01.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class ProfileEditingViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    
    private let viewModel: ProfileEditingViewModel
    
    // MARK: UI Components
    
    private lazy var containerScrollView: UIScrollView = .init().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
    }
    
    private lazy var contentView: UIView = .init().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var profileImageView: UIImageView = .init(image: .init(named: "테스트이미지")).then {
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var profileEditButton: UIButton = .init(type: .system).then {
        let imagePickerController: UIImagePickerController = .init().then {
            $0.delegate = self
            $0.allowsEditing = true
        }
        let action: UIAction = .init { [weak self] _ in
            self?.present(imagePickerController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
        $0.setTitle("프로필 사진 변경하기", for: .normal)
        $0.configuration = .borderless()
    }
    
    private lazy var nameTextField: InsetTextField = .init().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 20)
        $0.textAlignment = .center
        $0.placeholder = "이름"
        $0.keyboardType = .namePhonePad
        $0.autocorrectionType = .no
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.tertiaryLabel.cgColor
        $0.layer.borderWidth = 1.0
    }
    
    private lazy var totalUserInfoItemHeaderLabel: HeaderLabel = .init(title: "기본정보")
    
    private lazy var userInfoItemTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.delegate = self
        $0.register(UserInfoItemCell.self, forCellReuseIdentifier: UserInfoItemCell.reuseIdentifier)
        $0.backgroundColor = .clear
    }
    
    private lazy var userInfoItemAdditionButton: ItemAddButton = .init().then {
        let action: UIAction = .init(handler: { [weak self] _ in
            self?.pushOtherItemAdditionViewController()
        })
        $0.addAction(action, for: .touchUpInside)
    }
    
    private lazy var educationHeaderLabel: HeaderLabel = .init(title: "학력")
    
    private lazy var educationTableView: IntrinsicHeightTableView = .init(frame: .zero, style: .insetGrouped).then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        let cellType = EducationCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    private lazy var educationItemAddButton: ItemAddButton = .init().then {
        let action: UIAction = .init(handler: { [weak self] _ in
            let viewModel: EducationEditingViewModel = .init(
                educationItem: .empty,
                editingType: .new,
                delegate: self?.viewModel
            )
            let viewController: EducationEditingViewController = .init(viewModel: viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        })
        $0.addAction(action, for: .touchUpInside)
    }
    
    private lazy var logoutButton: UIButton = .init(
        configuration: .bordered().with {
            $0.baseBackgroundColor = .secondarySystemGroupedBackground
            $0.baseForegroundColor = .systemRed
            $0.title = "로그아웃"
            $0.buttonSize = .medium
        },
        primaryAction: UIAction { [weak self] _ in
            guard let self = self else { return }
            self.present(self.logoutAlertViewController, animated: true)
        }
    )
    
    private lazy var logoutAlertViewController: CommonAlertViewController = .init(
        title: "로그아웃",
        message: "로그아웃하시겠습니까?",
        style: .confirm,
        okHandler: { [weak self] in
            #if DEBUG
                print("Logout.")
            #endif
        }
    )
    
    private lazy var editingCompleteButton: UIBarButtonItem = .init(title: "수정완료").then {
        $0.style = .done
    }
    
    private lazy var backButton: UIBarButtonItem = .init(systemItem: .cancel).then {
        $0.primaryAction = .init(handler: { [weak self] _ in
            let title = "정말로 뒤로 가시겠습니까?"
            let message = "소중한 회원님의 정보는 되돌릴 수 없습니다. 이 사실을 인지하고 뒤로 가시겠습니까?"
            let alertVC = CommonAlertViewController(title: title, message: message, style: .confirm, okHandler: {
                self?.dismiss(animated: true)
            })
            self?.present(alertVC, animated: true)
        })
    }
    
    // MARK: - Initializer
    
    init(viewModel: ProfileEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureSubviews()
        self.view.backgroundColor = .systemGroupedBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameTextField.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.circular()
    }
}

// MARK: - Binding ViewModel

private extension ProfileEditingViewController {
    
    func bindViewModel() {
        let input = ProfileEditingViewModel.Input.init(
            tapEditingCompleteButton: editingCompleteButton.rx.tap.asSignal(),
            userName: nameTextField.rx.text.orEmpty.asDriver(),
            viewDidLoad: .just(())
        )
        let output = viewModel.transform(input: input)
        [
            output.viewDidLoad
                .drive(),
            output.userName
                .drive(nameTextField.rx.text),
            output.userInfoItems
                .drive(
                    userInfoItemTableView.rx.items(
                        cellIdentifier: UserInfoItemCell.reuseIdentifier,
                        cellType: UserInfoItemCell.self
                    )
                ) { (index, userInfoItem, cell) in
                    cell.bind(userInfoItem: userInfoItem)
                    cell.accessoryType = .disclosureIndicator
                },
            output.educationItems
                .drive(
                    educationTableView.rx.items(cellIdentifier: EducationCell.reuseIdentifier, cellType: EducationCell.self)
                ) { (index, educationItem, cell) in
                    cell.bind(educationItem: educationItem)
                },
            output.tappedEditingCompleteButton
                .emit(with: self, onNext: { owner, userInfo in
                    owner.dismiss(animated: true)
                }),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: - Private functions

private extension ProfileEditingViewController {
    
    func configureSubviews() {
        let headerHorizontalInsetValue = 26
        
        self.view.addSubview(containerScrollView)
        containerScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.containerScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.width.equalToSuperview()
        }
        
        self.contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(self.view.frame.width / 2.5)
            make.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(profileEditButton)
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        self.contentView.addSubview(totalUserInfoItemHeaderLabel)
        totalUserInfoItemHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(headerHorizontalInsetValue)
        }
        
        let headerLabelToTableViewOffset = -26
        
        self.contentView.addSubview(userInfoItemTableView)
        userInfoItemTableView.snp.makeConstraints { make in
            make.top.equalTo(totalUserInfoItemHeaderLabel.snp.bottom).offset(headerLabelToTableViewOffset)
            make.left.right.equalToSuperview()
        }
        
        let tableViewToAdditionButtonOffset = -28
        let additionButtonHorizontalInset = 20
        
        self.contentView.addSubview(userInfoItemAdditionButton)
        userInfoItemAdditionButton.snp.makeConstraints { make in
            make.top.equalTo(userInfoItemTableView.snp.bottom).offset(tableViewToAdditionButtonOffset)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(additionButtonHorizontalInset)
            make.height.equalTo(36)
        }
        
        self.contentView.addSubview(educationHeaderLabel)
        educationHeaderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(headerHorizontalInsetValue)
            make.top.equalTo(userInfoItemAdditionButton.snp.bottom).offset(20)
        }
        
        self.contentView.addSubview(educationTableView)
        educationTableView.snp.makeConstraints { make in
            make.top.equalTo(educationHeaderLabel.snp.bottom).offset(headerLabelToTableViewOffset)
            make.left.right.equalToSuperview()
        }
        
        self.contentView.addSubview(educationItemAddButton)
        educationItemAddButton.snp.makeConstraints { make in
            make.top.equalTo(educationTableView.snp.bottom).offset(tableViewToAdditionButtonOffset)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(additionButtonHorizontalInset)
            make.height.equalTo(42)
        }
        
        self.contentView.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(additionButtonHorizontalInset)
            make.top.equalTo(educationItemAddButton.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "프로필 수정"
        self.navigationItem.rightBarButtonItem = editingCompleteButton
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func presentDatePickerView() {
        let viewController: BirthdayEditingViewController = .init(viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(viewController, animated: false)
    }
    
    func presentAddressEditingView() {
        let viewController: AddressEditingViewController = .init(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentPhoneNumberEditingView() {
        let viewController: PhoneNumberEditingViewController = .init(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentEmailEditingView() {
        let viewController: EmailEditingViewController = .init(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushOtherItemEditingViewController(with otherItem: UserInfoItem) {
        guard let indexOfItem = viewModel.currentOtherItems.firstIndex(where: { $0 === otherItem }) else {
            return
        }
        let viewModel: OtherItemEditingViewModel = .init(
            initalOtherItem: otherItem,
            editingType: .edit(index: indexOfItem),
            delegate: viewModel
        )
        let viewController: OtherItemEditingViewController = .init(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushOtherItemAdditionViewController() {
        let viewModel: OtherItemEditingViewModel = .init(
            initalOtherItem: .empty,
            editingType: .new,
            delegate: viewModel
        )
        let viewController: OtherItemEditingViewController = .init(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentUserInfoItemInputView(by indexPath: IndexPath) {
        switch viewModel.currentAllItems[ifExists: indexPath.row]?.icon {
        case .cake:
            presentDatePickerView()
        case .house:
            presentAddressEditingView()
        case .phone:
            presentPhoneNumberEditingView()
        case .letter:
            presentEmailEditingView()
        default:
            if let otherItem = viewModel.currentAllItems[ifExists: indexPath.row] {
                pushOtherItemEditingViewController(with: otherItem)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ProfileEditingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch tableView {
        case educationTableView:
            let removeAction: UIContextualAction = .init(style: .destructive, title: "삭제") { (action, view, completionHandler) in
                self.viewModel.deleteEducationItem(at: indexPath)
                completionHandler(true)
            }
            let config: UIImage.SymbolConfiguration = .init(pointSize: 24.0, weight: .semibold, scale: .default)
            removeAction.image = .init(systemName: "minus.circle", withConfiguration: config)
            return .init(actions: [removeAction])
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case userInfoItemTableView:
            presentUserInfoItemInputView(by: indexPath)
        case educationTableView:
            guard let educationItem = viewModel.currentEducationItems[ifExists: indexPath.row] else {
                return
            }
            let viewModel: EducationEditingViewModel = .init(
                educationItem: educationItem,
                editingType: .edit(indexPath: indexPath),
                delegate: viewModel
            )
            let viewController: EducationEditingViewController = .init(viewModel: viewModel)
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            return
        }
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileEditingViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)
        
        if let croppedImage = info[.editedImage] as? UIImage {
            profileImageView.image = croppedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension ProfileEditingViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nameTextField.resignFirstResponder()
    }
}

// MARK: - UINavigationControllerDelegate

extension ProfileEditingViewController: UINavigationControllerDelegate {
}

#if DEBUG

// MARK: - Canvas

import SwiftUI

@available(iOS 13.0, *)
struct ProfileEditingViewControllerRepresenter: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let navigationController: UINavigationController = .init(rootViewController: .init())
        let profileEditingViewModel: ProfileEditingViewModel = .init(userInfo: .empty)
        let profileEditingViewController: ProfileEditingViewController = .init(viewModel: profileEditingViewModel)
        navigationController.pushViewController(profileEditingViewController, animated: false)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

@available(iOS 13.0, *)
struct ProfileEditingViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        ProfileEditingViewControllerRepresenter()
    }
}

#endif
