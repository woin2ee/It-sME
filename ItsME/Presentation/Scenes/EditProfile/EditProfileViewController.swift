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
        $0.backgroundColor = .systemBackground
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var contentView: UIView = .init().then {
        $0.backgroundColor = .systemBackground
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
    
    private lazy var totalUserInfoItemStackView: UserInfoItemStackView = .init()
    
    private lazy var userInfoItemAddButton: ItemAddButton = .init().then {
        let action: UIAction = .init(handler: { [weak self] _ in
            guard let self = self else { return }
            let otherItemEditingVC: OtherItemEditingViewController = .init(viewModel: self.viewModel)
            self.navigationController?.pushViewController(otherItemEditingVC, animated: true)
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
        self.view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
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
            userName: nameTextField.rx.text.orEmpty.asDriver()
        )
        let output = viewModel.transform(input: input)
        
        output.userName
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.userInfoItems
            .drive(with: self, onNext: { owner, userInfoItems in
                owner.totalUserInfoItemStackView.bind(userInfoItems: userInfoItems)
            })
            .disposed(by: disposeBag)
        
        output.educationItems
            .drive(
                educationTableView.rx.items(cellIdentifier: EducationCell.reuseIdentifier, cellType: EducationCell.self)
            ) { (index, educationItem, cell) in
                cell.bind(educationItem: educationItem)
            }
            .disposed(by: disposeBag)
        
        output.tappedEditingCompleteButton
            .emit(with: self, onNext: { owner, userInfo in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
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
            make.left.right.equalToSuperview().inset(30)
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
        self.navigationItem.title = "Edit Profile"
        self.navigationItem.rightBarButtonItem = editingCompleteButton
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
