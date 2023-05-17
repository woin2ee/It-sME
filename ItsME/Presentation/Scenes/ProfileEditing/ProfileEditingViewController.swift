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
    
    private lazy var profileImageView: UIImageView = .init().then {
        $0.image = .defaultProfileImage
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var profileEditButton: UIButton = .init(type: .system).then {
        let action: UIAction = .init { [weak self] _ in
            guard let self = self else { return }
            self.present(self.imagePickerController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
        $0.setTitle("프로필 사진 변경하기", for: .normal)
        $0.configuration = .borderless()
    }
    
    private lazy var imagePickerController: UIImagePickerController = .init().then {
        $0.allowsEditing = true
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
        $0.accessibilityIdentifier = "PROFILE_EDITING__NAME_TEXT_FIELD"
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
        let cellType = MovableEducationCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(respondToLongPressGesture))
        $0.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    private lazy var educationItemAddButton: ItemAddButton = .init().then {
        let action: UIAction = .init(handler: { [weak self] _ in
            let viewModel: EducationEditingViewModel = .init(
                editingType: .new,
                delegate: self?.viewModel
            )
            let viewController: EducationEditingViewController = .init(viewModel: viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        })
        $0.addAction(action, for: .touchUpInside)
    }
    
    private lazy var logoutButton: UIButton = .init(configuration: .bordered().with {
        $0.baseBackgroundColor = .secondarySystemGroupedBackground
        $0.baseForegroundColor = .systemRed
        $0.title = "로그아웃"
        $0.buttonSize = .medium
    })
    
    private lazy var deleteAccountButton: UIButton = .init(configuration: .bordered().with {
        $0.baseBackgroundColor = .systemRed
        $0.baseForegroundColor = .white
        $0.title = "계정 삭제하기"
        $0.buttonSize = .medium
    })
    
    private lazy var editingCompleteButton: UIBarButtonItem = .init(title: "수정완료").then {
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
                    self?.dismiss(animated: true)
                })
            )
        })
    }
    
    private var sourceIndexPath: IndexPath?
    private var educationCellSnapshot: UIImageView?
    private var centerYOffset: CGFloat?
    
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
            viewDidLoad: .just(()),
            logoutTrigger: logoutButton.rx.tap.asSignal().flatMapFirst { [weak self] _ in
                guard let self = self else { return .empty() }
                return self.rx.presentConfirmAlert(
                    title: "로그아웃",
                    message: "로그아웃하시겠습니까?",
                    okAction: UIAlertAction(title: "예", style: .default)
                ).asSignal()
            },
            deleteAccountTrigger: deleteAccountButton.rx.tap.asSignal().flatMapFirst { [weak self] _ in
                guard let self = self else { return .empty() }
                return self.rx.presentConfirmAlert(
                    title: "계정 삭제",
                    message: "계정을 삭제하면 관련된 모든 데이터가 삭제되어 되돌릴 수 없습니다.",
                    okAction: UIAlertAction(title: "삭제", style: .destructive)
                ).asSignal()
            },
            newProfileImageData: imagePickerController.rx.didFinishPickingImage(animated: true)
                .map { $0?.jpegData(compressionQuality: 0.7) }
                .asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        [
            output.viewDidLoad
                .drive(),
            output.profileImageData
                .map { imageData -> UIImage in
                    guard let imageData = imageData, let profileImage = UIImage(data: imageData) else {
                        return UIImage.defaultProfileImage
                    }
                    return profileImage
                }
                .drive(profileImageView.rx.image),
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
                    educationTableView.rx.items(cellIdentifier: MovableEducationCell.reuseIdentifier, cellType: MovableEducationCell.self)
                ) { (index, educationItem, cell) in
                    cell.bind(educationItem: educationItem)
                },
            output.tappedEditingCompleteButton
                .emit(with: self, onNext: { owner, userInfo in
                    owner.presentingViewController?.dismiss(animated: true)
                }),
            output.logoutComplete
                .emit(with: self, onNext: { owner, _ in
                    let loginViewController = DIContainer.makeLoginViewController()
                    owner.navigationController?.setViewControllers([loginViewController], animated: false)
                }),
            output.deleteAccountComplete
                .emit(with: self, onNext: { owner, _ in
                    let alertController: UIAlertController = .init(title: "", message: "계정 삭제가 완료되었습니다.", preferredStyle: .alert)
                    let okAction: UIAlertAction = .init(title: "확인", style: .default) { _ in
                        let loginViewController = DIContainer.makeLoginViewController()
                        owner.navigationController?.setViewControllers([loginViewController], animated: false)
                    }
                    alertController.addAction(okAction)
                    owner.present(alertController, animated: true)
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
            make.directionalEdges.width.equalToSuperview()
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
            make.top.equalTo(educationItemAddButton.snp.bottom).offset(40)
        }
        
        self.contentView.addSubview(deleteAccountButton)
        deleteAccountButton.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(additionButtonHorizontalInset)
            make.top.equalTo(logoutButton.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(20)
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
        let viewModel: AddressEditingViewModel = .init(initialAddress: viewModel.currentAddress, delegate: viewModel)
        let viewController: AddressEditingViewController = .init(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentPhoneNumberEditingView() {
        let viewModel: PhoneNumberEditingViewModel = .init(initialPhoneNumber: viewModel.currentPhoneNumber, delegate: viewModel)
        let viewController: PhoneNumberEditingViewController = .init(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentEmailEditingView() {
        let viewModel: EmailEditingViewModel = .init(initialEmail: viewModel.currentEmail, delegate: viewModel)
        let viewController: EmailEditingViewController = .init(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushOtherItemEditingViewController(with otherItem: UserBasicProfileInfo) {
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
    
    func presentUserInfoItemInputView(by index: IndexPath.Index) {
        switch index {
        case 0:
            presentDatePickerView()
        case 1:
            presentAddressEditingView()
        case 2:
            presentPhoneNumberEditingView()
        case 3:
            presentEmailEditingView()
        default:
            if let otherItem = viewModel.currentAllItems[ifExists: index] {
                pushOtherItemEditingViewController(with: otherItem)
            }
        }
    }
    
    @objc func respondToLongPressGesture(sender: UILongPressGestureRecognizer) {
        let pointInTableView = sender.location(in: educationTableView)
        
        switch sender.state {
        case .began:
            guard let selectedIndexPath = educationTableView.indexPathForRow(at: pointInTableView),
                  let selectedCell = educationTableView.cellForRow(at: selectedIndexPath)
            else { return }
            
            selectedCell.setHighlighted(false, animated: false)
            
            sourceIndexPath = selectedIndexPath
            centerYOffset = pointInTableView.y - selectedCell.center.y
            educationCellSnapshot = UIImageView(image: selectedCell.asImage())
            
            guard let educationCellSnapshot = educationCellSnapshot else { return }
            
            let centerX = selectedCell.convert(selectedCell.center, to: educationTableView).x
            let centerY = selectedCell.center.y
            educationCellSnapshot.center = .init(x: centerX, y: centerY)
            
            educationTableView.addSubview(educationCellSnapshot)
            
            UIView.animate(withDuration: 0.2) {
                educationCellSnapshot.transform = .init(scaleX: 1.03, y: 1.03)
                educationCellSnapshot.alpha = 0.8
                
                selectedCell.isHidden = true
            }
            
        case .changed:
            guard let selectedIndexPath = educationTableView.indexPathForRow(at: pointInTableView),
                  let selectedCell = educationTableView.cellForRow(at: selectedIndexPath),
                  let educationCellSnapshot = educationCellSnapshot,
                  let centerYOffset = centerYOffset,
                  let sourceIndexPath = sourceIndexPath
            else { return }
            
            let centerX = selectedCell.convert(selectedCell.center, to: educationTableView).x
            let centerY = pointInTableView.y - centerYOffset
            educationCellSnapshot.center = .init(x: centerX, y: centerY)
            
            if sourceIndexPath != selectedIndexPath {
                educationTableView.moveRow(at: sourceIndexPath, to: selectedIndexPath)
                viewModel.swapEducation(at: sourceIndexPath, to: selectedIndexPath)
                self.sourceIndexPath = selectedIndexPath
            }
            
        default:
            if let sourceIndexPath = sourceIndexPath,
               let sourceCell = educationTableView.cellForRow(at: sourceIndexPath) {
                viewModel.endSwapEducation()
                sourceCell.isHidden = false
            }
            
            educationCellSnapshot?.removeFromSuperview()
            educationCellSnapshot = nil
            sourceIndexPath = nil
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
            presentUserInfoItemInputView(by: indexPath.row)
        case educationTableView:
            guard let educationItem = viewModel.currentEducationItems[ifExists: indexPath.row] else {
                return
            }
            let viewModel: EducationEditingViewModel = .init(
                editingType: .edit(index: indexPath.row, target: educationItem),
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

// MARK: - UIScrollViewDelegate

extension ProfileEditingViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nameTextField.resignFirstResponder()
    }
}

#if DEBUG

// MARK: - Canvas

import SwiftUI

@available(iOS 13.0, *)
struct ProfileEditingViewControllerRepresenter: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let navigationController: UINavigationController = .init(rootViewController: .init())
        let profileEditingViewController = DIContainer.mock.makeProfileEditingViewController()
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
