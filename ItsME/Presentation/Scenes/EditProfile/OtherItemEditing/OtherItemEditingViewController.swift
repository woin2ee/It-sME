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
    
    private lazy var iconButton: UIButton = .init().then {
        $0.setTitle(UserInfoItemIcon.default.toEmoji, for: .normal)
        let action: UIAction = .init { _ in
            print("Touch")
        }
        $0.addAction(action, for: .touchUpInside)
    }
    
    private lazy var contentsTextField: UITextField = .init().then {
        $0.delegate = self
        $0.font = .systemFont(ofSize: 16.0)
        $0.borderStyle = .roundedRect
        $0.placeholder = "http://example.com"
        $0.autocorrectionType = .no
        $0.keyboardType = .URL
        $0.autocapitalizationType = .none
    }
    
    private lazy var containerStackView: UIStackView = .init().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 10.0
    }
    
    private lazy var completeButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "추가", handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            let emojiName = self.iconButton.titleLabel?.text ?? UserInfoItemIcon.default.toEmoji
            let icon: UserInfoItemIcon = .init(rawValue: emojiName) ?? .default
            let newItem: UserInfoItem = .init(
                icon: icon,
                contents: self.contentsTextField.text!
            )
            self.viewModel.addUserInfoItem(newItem)
        })
    }
    
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
        self.view.backgroundColor = .systemBackground
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

// MARK: - Private Functions

private extension OtherItemEditingViewController {
    
    func configureSubviews() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.containerStackView.addArrangedSubview(iconButton)
        self.containerStackView.addArrangedSubview(contentsTextField)
        
        self.view.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(10)
            make.leading.trailing.equalTo(safeArea).inset(10)
            make.height.equalTo(40)
        }
        
        iconButton.snp.makeConstraints { make in
            make.width.height.equalTo(contentsTextField.snp.height)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "새 항목"
        self.navigationItem.rightBarButtonItem = completeButton
    }
}

// MARK: - UITextFieldDelegate

extension OtherItemEditingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
