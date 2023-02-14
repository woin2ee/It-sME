//
//  EditProfileViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/01.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class EditProfileViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    
    private let viewModel: EditProfileViewModel
    
    // MARK: - UI Components
    
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
    }
    
    private lazy var nameTextField: UITextField = .init().then {
        $0.borderStyle = .line
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 20)
        $0.textAlignment = .center
        $0.placeholder = "이름"
        $0.keyboardType = .namePhonePad
        $0.autocorrectionType = .no
    }
    
    private lazy var totalUserInfoItemStackView: UserInfoItemStackView = .init().then {
        $0.hasSeparator = true
        $0.backgroundColor = .systemBackground
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 12.0
    }
    
    private lazy var userInfoItemAddButton: ItemAddButton = .init().then {
        let action: UIAction = .init(handler: { [weak self] _ in
            self?.presentNewOtherItemView()
        })
        $0.addAction(action, for: .touchUpInside)
    }
    
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
        let cellType = EducationCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    private lazy var educationItemAddButton: ItemAddButton = .init()
    
    private lazy var editingCompleteButton: UIBarButtonItem = .init(title: "수정완료")
    
    // MARK: - Initializer
    
    init(viewModel: EditProfileViewModel) {
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
        self.view.backgroundColor = .secondarySystemBackground
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

private extension EditProfileViewController {
    
    func bindViewModel() {
        let input = EditProfileViewModel.Input.init(
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
                .drive(with: self, onNext: { owner, userInfoItems in
                    owner.totalUserInfoItemStackView.bind(userInfoItems: userInfoItems)
                    zip(owner.totalUserInfoItemStackView.arrangedSubviews, userInfoItems)
                        .forEach { (subview, userInfoItem) in
                            let action = owner.decideTransitionAction(by: userInfoItem)
                            let tapGestureRecognizer: UITapGestureRecognizer = .init(target: owner, action: action)
                            subview.addGestureRecognizer(tapGestureRecognizer)
                        }
                }),
            output.educationItems
                .drive(
                    educationTableView.rx.items(cellIdentifier: EducationCell.reuseIdentifier, cellType: EducationCell.self)
                ) { (index, educationItem, cell) in
                    cell.bind(educationItem: educationItem)
                },
            output.tappedEditingCompleteButton
                .emit(with: self, onNext: { owner, userInfo in
                    owner.navigationController?.popViewController(animated: true)
                }),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
}

// MARK: - Private functions

private extension EditProfileViewController {
    
    func configureSubviews() {
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
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        self.contentView.addSubview(totalUserInfoItemStackView)
        totalUserInfoItemStackView.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(25)
            make.left.right.equalToSuperview().inset(16)
        }
        
        self.contentView.addSubview(userInfoItemAddButton)
        userInfoItemAddButton.snp.makeConstraints { make in
            make.top.equalTo(totalUserInfoItemStackView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(36)
        }
        
        self.contentView.addSubview(educationHeaderLabel)
        educationHeaderLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(userInfoItemAddButton.snp.bottom).offset(20)
        }
        
        self.contentView.addSubview(educationTableView)
        educationTableView.snp.makeConstraints { make in
            make.top.equalTo(educationHeaderLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(24)
        }
        
        self.contentView.addSubview(educationItemAddButton)
        educationItemAddButton.snp.makeConstraints { make in
            make.top.equalTo(educationTableView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(42)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "프로필 수정"
        self.navigationItem.rightBarButtonItem = editingCompleteButton
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func presentDatePickerView() {
        let viewController: BirthdayEditingViewController = .init(viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(viewController, animated: false)
    }
    
    @objc func presentAddressEditingView() {
        let viewController: AddressEditingViewController
        print(#function)
    }
    
    @objc func presentPhoneNumberEditingView() {
        let viewController: PhoneNumberEditingViewController
        print(#function)
    }
    
    @objc func presentEmailEditingView() {
        let viewController: EmailEditingViewController
        print(#function)
    }
    
    @objc func presentOtherItemEditingView(_ sender: UITapGestureRecognizer) {
        guard let userInfoItem = (sender.view as? ProfileInfoComponent)?.userInfoItem,
              let indexOfItem = viewModel.currentOtherItems.firstIndex(where: { $0 === userInfoItem })
        else {
            return
        }
        
        let viewController: OtherItemEditingViewController = .init(viewModel: viewModel, indexOfItem: indexOfItem)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func decideTransitionAction(by userInfoItem: UserInfoItem) -> Selector {
        switch userInfoItem.icon {
        case .cake:
            return #selector(presentDatePickerView)
        case .house:
            return #selector(presentAddressEditingView)
        case .phone:
            return #selector(presentPhoneNumberEditingView)
        case .letter:
            return #selector(presentEmailEditingView)
        default:
            return #selector(presentOtherItemEditingView)
        }
    }
    
    func presentNewOtherItemView() {
        let viewController: NewOtherItemViewController = .init(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension EditProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction: UIContextualAction = .init(style: .destructive, title: "삭제") { (action, view, completionHandler) in
            self.viewModel.deleteEducationItem(at: indexPath)
            completionHandler(true)
        }
        let config: UIImage.SymbolConfiguration = .init(pointSize: 24.0, weight: .semibold, scale: .default)
        removeAction.image = .init(systemName: "minus.circle", withConfiguration: config)
        
        return .init(actions: [removeAction])
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate {
    
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

extension EditProfileViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nameTextField.resignFirstResponder()
    }
}

// MARK: - UINavigationControllerDelegate

extension EditProfileViewController: UINavigationControllerDelegate {
}

#if DEBUG

// MARK: - Canvas

import SwiftUI

@available(iOS 13.0, *)
struct EditProfileViewControllerRepresenter: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let navigationController: UINavigationController = .init(rootViewController: .init())
        let editProfileViewModel: EditProfileViewModel = .init(userInfo: .empty)
        let editProfileViewController: EditProfileViewController = .init(viewModel: editProfileViewModel)
        navigationController.pushViewController(editProfileViewController, animated: false)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

@available(iOS 13.0, *)
struct EditProfileViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        EditProfileViewControllerRepresenter()
    }
}

#endif
