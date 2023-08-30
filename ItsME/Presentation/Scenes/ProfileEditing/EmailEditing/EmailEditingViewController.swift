//
//  EmailEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/10.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class EmailEditingViewController: UIViewController {

    private let disposeBag: DisposeBag = .init()
    private let viewModel: EmailEditingViewModel

    // MARK: - UI Components

    private lazy var inputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.backgroundColor = .clear
    }

    private lazy var inputCell: ContentsInputCell = .init().then {
        $0.titleLabel.text = "이메일"
    }

    private lazy var completeBarButton: UIBarButtonItem = .init(title: "완료")

    // MARK: - Initalizer

    init(viewModel: EmailEditingViewModel) {
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
        inputCell.contentsTextField.becomeFirstResponder()
    }
}

// MARK: - Private Functions

private extension EmailEditingViewController {

    func configureSubviews() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.view.addSubview(inputTableView)
        inputTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
        }
    }

    func configureNavigationBar() {
        self.navigationItem.title = "이메일 편집"
        self.navigationItem.rightBarButtonItem = completeBarButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
}

// MARK: - Binding ViewModel

extension EmailEditingViewController {

    private func bindViewModel() {
        let input: EmailEditingViewModel.Input = .init(
            email: inputCell.contentsTextField.rx.text.orEmpty.asDriver(),
            saveTrigger: completeBarButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)

        [
            output.email
                .drive(inputCell.contentsTextField.rx.text),
            output.email
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

extension EmailEditingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return inputCell
    }
}
