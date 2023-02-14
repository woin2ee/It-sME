//
//  OtherItemEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/10.
//

import SnapKit
import Then
import UIKit

final class OtherItemEditingViewController: UIViewController {
    
    private let viewModel: EditProfileViewModel
    
    private var indexOfItem: IndexPath.Index
    
    private lazy var userInfoItemInputView: UserInfoItemInputView = .init().then {
        $0.contentsTextField.delegate = self
        let userInfoItem = viewModel.currentOtherItems[ifExists: indexOfItem]
        $0.iconButton.setTitle(userInfoItem?.icon.toEmoji, for: .normal)
        $0.contentsTextField.text = userInfoItem?.contents
    }
    
    private lazy var completeButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "완료", handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            
            let emojiName = self.userInfoItemInputView.iconButton.titleLabel?.text ?? UserInfoItemIcon.default.toEmoji
            let icon: UserInfoItemIcon = .init(rawValue: emojiName) ?? .default
            let contents = self.userInfoItemInputView.contentsTextField.text!
            let item: UserInfoItem = .init(
                icon: icon,
                contents: contents
            )
            self.viewModel.updateUserInfoItem(item, at: self.indexOfItem)
        })
    }
    
    // MARK: - Initializer
    
    init(viewModel: EditProfileViewModel, indexOfItem: IndexPath.Index) {
        self.viewModel = viewModel
        self.indexOfItem = indexOfItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

// MARK: - Private Functions

private extension OtherItemEditingViewController {
    
    func configureSubviews() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(userInfoItemInputView)
        userInfoItemInputView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(10)
            make.leading.trailing.equalTo(safeArea).inset(10)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "항목 수정"
        self.navigationItem.rightBarButtonItem = completeButton
    }
}

// MARK: - UITextFieldDelegate

extension OtherItemEditingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
