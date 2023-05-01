//
//  AddressEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/10.
//

import SnapKit
import Then
import UIKit

final class AddressEditingViewController: UIViewController {
    
    private let viewModel: ProfileEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var addressTextView: IntrinsicHeightTextView = .init().then {
        $0.text = viewModel.currentAddress
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.textContainerInset = .init(top: 10, left: 4, bottom: 10, right: 4)
        $0.font = .systemFont(ofSize: 18)
        $0.keyboardType = .twitter
        $0.layer.cornerRadius = 12.0
    }
    
    private lazy var completeBarButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "완료", handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
            self?.updateAddres()
        })
    }
    
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
        self.view.backgroundColor = .systemGroupedBackground
        configureSubviews()
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addressTextView.becomeFirstResponder()
    }
}

// MARK: - Private Functions

private extension AddressEditingViewController {
    
    func configureSubviews() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.view.addSubview(addressTextView)
        addressTextView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalTo(safeArea).inset(20)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "주소 편집"
        self.navigationItem.rightBarButtonItem = completeBarButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
    
    func updateAddres() {
        let address: String = addressTextView.text
        viewModel.updateAddress(address)
    }
}
