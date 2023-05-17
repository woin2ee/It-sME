//
//  AddressEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/10.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class AddressEditingViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    private let viewModel: AddressEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var addressTextView: IntrinsicHeightTextView = .init().then {
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.textContainerInset = .init(top: 10, left: 4, bottom: 10, right: 4)
        $0.font = .systemFont(ofSize: 18)
        $0.keyboardType = .default
        $0.returnKeyType = .done
        $0.layer.cornerRadius = 12.0
    }
    
    private lazy var completeBarButton: UIBarButtonItem = .init(title: "완료")
    
    // MARK: - Initializer
    
    init(viewModel: AddressEditingViewModel) {
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
        bindViewModel()
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
}

// MARK: - Binding ViewModel

extension AddressEditingViewController {
    
    private func bindViewModel() {
        let input = AddressEditingViewModel.Input.init(
            address: addressTextView.rx.text.orEmpty.asDriver(),
            saveTrigger: completeBarButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        [
            output.address
                .drive(addressTextView.rx.text),
            output.address
                .map(\.isNotEmpty)
                .drive(completeBarButton.rx.isEnabled),
            output.saveComplete
                .emit(with: self, onNext: { owner, _ in
                    owner.navigationController?.popViewController(animated: true)
                }),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
}
