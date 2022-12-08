//
//  EditProfileViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/01.
//

import RxSwift
import SnapKit
import UIKit

final class EditProfileViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    
    private let viewModel: EditProfileViewModel = .init()
    
    // MARK: UI Components
    
    private lazy var containerScrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView: UIImageView = .init(image: UIImage.init(named: "테스트이미지"))
        return imageView
    }()
    
    private lazy var profileEditButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setTitle("프로필 사진 변경하기", for: .normal)
        return button
    }()
    
    private lazy var totalUserInfoItemStackView: TotalUserInfoItemStackView = .init()
    
    private lazy var userInfoItemAddButton: ItemAddButton = .init(type: .system)
    
    private lazy var educationTableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.backgroundColor = .systemGray2
        return tableView
    }()

    private lazy var educationItemAddButton: ItemAddButton = .init(type: .system)
    
    private lazy var editingCompleteButton: UIBarButtonItem = {
        let button: UIBarButtonItem = .init()
        button.title = "수정완료"
        return button
    }()
    
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
        let input = EditProfileViewModel.Input.init()
        let output = viewModel.transform(input: input)
        
        _ = output
    }
}

// MARK: - Private functions

private extension EditProfileViewController {
    
    func configureSubviews() {
        self.view.addSubview(containerScrollView)
        containerScrollView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.containerScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.width.equalToSuperview()
        }
        
        self.contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(150)
            make.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(profileEditButton)
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(totalUserInfoItemStackView)
        totalUserInfoItemStackView.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(300) // FIXME: 임시로 세팅(자동으로 계산됨)
        }
        
        self.contentView.addSubview(userInfoItemAddButton)
        userInfoItemAddButton.snp.makeConstraints { make in
            make.top.equalTo(totalUserInfoItemStackView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        self.contentView.addSubview(educationTableView)
        educationTableView.snp.makeConstraints { make in
            make.top.equalTo(userInfoItemAddButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(300) // FIXME: 임시로 세팅(자동으로 계산됨)
        }
        
        self.contentView.addSubview(educationItemAddButton)
        educationItemAddButton.snp.makeConstraints { make in
            make.top.equalTo(educationTableView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "Edit Profile"
        self.navigationItem.rightBarButtonItem = editingCompleteButton
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

#if DEBUG

// MARK: - Canvas

import SwiftUI

@available(iOS 13.0, *)
struct EditProfileViewControllerRepresenter: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let navigationController: UINavigationController = .init(rootViewController: .init())
        let editProfileViewController: EditProfileViewController = .init()
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
