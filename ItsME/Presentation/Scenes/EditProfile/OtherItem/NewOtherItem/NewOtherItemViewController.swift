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
    
    private lazy var userInfoItemInputTableView: UserInfoItemInputTableView = .init(style: .insetGrouped)
    
    private lazy var completeButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "추가", handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            self.saveUserInfoItem()
        })
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        configureSubviews()
        configureNavigationBar()
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
        self.view.addSubview(userInfoItemInputTableView)
        userInfoItemInputTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "새 항목"
        self.navigationItem.rightBarButtonItem = completeButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
    
    func saveUserInfoItem() {
        let newItem = userInfoItemInputTableView.currentUserInfoItem
        self.viewModel.appendUserInfoItem(newItem)
    }
}
