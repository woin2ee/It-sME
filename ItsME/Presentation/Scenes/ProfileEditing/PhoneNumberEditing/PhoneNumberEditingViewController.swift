//
//  PhoneNumberEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/10.
//

import ItsMEUtil
import RxSwift
import SnapKit
import Then
import UIKit

final class PhoneNumberEditingViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    private let viewModel: PhoneNumberEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var inputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.backgroundColor = .clear
    }
    
    private lazy var inputCell: ContentsInputCell = .init().then {
        $0.titleLabel.text = "전화번호"
        $0.contentsTextField.placeholder = "전화"
        $0.contentsTextField.delegate = self
        $0.contentsTextField.keyboardType = .numberPad
        $0.contentsTextField.returnKeyType = .done
    }
    
    private lazy var completeBarButton: UIBarButtonItem = .init(title: "완료")
    
    // MARK: - Initalizer
    
    init(viewModel: PhoneNumberEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        configureSubviews()
        configureNavigationBar()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputCell.contentsTextField.becomeFirstResponder()
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
}

// MARK: - Binding ViewModel

extension PhoneNumberEditingViewController {
    
    private func bindViewModel() {
        let input: PhoneNumberEditingViewModel.Input = .init(
            phoneNumber: inputCell.contentsTextField.rx.text.orEmpty.asDriver(),
            saveTrigger: completeBarButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        [
            output.phoneNumber
                .drive(inputCell.contentsTextField.rx.text),
            output.phoneNumber
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

// MARK: - UITableViewDataSource

extension PhoneNumberEditingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return inputCell
    }
}

// MARK: - UITextFieldDelegate

extension PhoneNumberEditingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isEntering = !(range.length > 0)
        let enteredText: String
        
        if isEntering {
            enteredText = (textField.text ?? "") + string
        } else {
            guard
                var currentText = textField.text,
                let removeRange = Range<String.Index>.init(range, in: currentText)
            else {
                return true
            }
            
            currentText.removeSubrange(removeRange)
            enteredText = currentText
        }
        
        textField.text = formatPhoneNumber(enteredText)
        textField.sendActions(for: .valueChanged)
        return false
    }
}
