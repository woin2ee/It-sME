//
//  NewOtherItemViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/13.
//

import SnapKit
import Then
import UIKit

final class NewOtherItemViewController: UIViewController {
    
    private let viewModel: EditProfileViewModel
    
    private lazy var userInfoItemInputView: UserInfoItemInputView = .init().then {
        $0.contentsTextField.delegate = self
    }
    
    private lazy var completeButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "추가", handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            
            let emojiName = self.userInfoItemInputView.iconButton.titleLabel?.text ?? UserInfoItemIcon.default.toEmoji
            let icon: UserInfoItemIcon = .init(rawValue: emojiName) ?? .default
            let contents = self.userInfoItemInputView.contentsTextField.text!
            let newItem: UserInfoItem = .init(
                icon: icon,
                contents: contents
            )
            self.viewModel.appendUserInfoItem(newItem)
        })
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureSubviews()
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userInfoItemInputView.contentsTextField.becomeFirstResponder()
    }
    
    // MARK: - Initializer
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Functions

private extension NewOtherItemViewController {
    
    func configureSubviews() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(userInfoItemInputView)
        userInfoItemInputView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(10)
            make.leading.trailing.equalTo(safeArea).inset(10)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "새 항목"
        self.navigationItem.rightBarButtonItem = completeButton
    }
}

// MARK: - UITextFieldDelegate

extension NewOtherItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
