//
//  PhoneNumberEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/10.
//

import SnapKit
import Then
import UIKit


final class PhoneNumberEditingViewController: UIViewController {
    
    private let viewModel: EditProfileViewModel
    
    // MARK: - UI Components
    
    private lazy var inputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
    }
    
    var inputCell: ContentsInputCell? {
        inputTableView.visibleCells[ifExists: 0] as? ContentsInputCell
    }
    
    private lazy var completeBarButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "완료", handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
            self?.updatePhoneNumber()
        })
    }
    
    // MARK: - Initalizer
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        configureSubviews()
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputCell?.contentsTextField.becomeFirstResponder()
    }
}

// MARK: - Private Functions

private extension PhoneNumberEditingViewController {
    
    func configureSubviews() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.view.addSubview(inputTableView)
        inputTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "전화번호 편집"
        self.navigationItem.rightBarButtonItem = completeBarButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
    
    func updatePhoneNumber() {
        let phoneNumber = inputCell?.contentsTextField.text ?? ""
        viewModel.updatePhoneNumber(phoneNumber)
    }
}

// MARK: - UITableViewDataSource

extension PhoneNumberEditingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContentsInputCell = .init()
        cell.titleLabel.text = "전화번호"
        cell.contentsTextField.text = viewModel.currentPhoneNumber
        cell.contentsTextField.placeholder = "전화"
        return cell
    }
}
