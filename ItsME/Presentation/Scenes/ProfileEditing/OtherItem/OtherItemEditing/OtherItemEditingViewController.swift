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
    
    private let viewModel: ProfileEditingViewModel
    
    private var indexOfItem: IndexPath.Index
    
    private lazy var userInfoItemInputTableView: UserInfoItemInputTableView = .init(style: .insetGrouped)
        .then {
            let userInfoItem: UserInfoItem = viewModel.currentOtherItems[ifExists: indexOfItem] ?? .empty
            $0.bind(userInfoItem: userInfoItem)
            $0.backgroundColor = .clear
        }
    
    private lazy var completeButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "완료", handler: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
            self.updateUserInfoItem()
        })
    }
    
    // MARK: - Initializer
    
    init(viewModel: ProfileEditingViewModel, indexOfItem: IndexPath.Index) {
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
        self.view.backgroundColor = .systemGroupedBackground
        configureSubviews()
        configureNavigationBar()
    }
}

// MARK: - Private Functions

private extension OtherItemEditingViewController {
    
    func configureSubviews() {
        self.view.addSubview(userInfoItemInputTableView)
        userInfoItemInputTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "항목 편집"
        self.navigationItem.rightBarButtonItem = completeButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
    
    func updateUserInfoItem() {
        let item = userInfoItemInputTableView.currentUserInfoItem
        self.viewModel.updateOtherUserInfoItem(item, at: indexOfItem)
    }
}
