//
//  OtherItemEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/10.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class OtherItemEditingViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    private let viewModel: OtherItemEditingViewModel
    
    // MARK: - UI Objects
    
    private lazy var userInfoItemInputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
    }
    private lazy var iconInputCell: IconInputCell = .init()
    private lazy var contentsInputCell: ContentsInputCell = .init()
    private lazy var completeButton: UIBarButtonItem = .init()
    
    // MARK: - Computed Properties
    
    var inputCells: [UITableViewCell] {
        [iconInputCell, contentsInputCell]
    }
    
    // MARK: - Initializer
    
    init(viewModel: OtherItemEditingViewModel) {
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
        contentsInputCell.contentsTextField.becomeFirstResponder()
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
        self.navigationItem.rightBarButtonItem = completeButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
}

// MARK: - Binding ViewModel

private extension OtherItemEditingViewController {
    
    func bindViewModel() {
        let input: OtherItemEditingViewModel.Input = makeInput()
        let output = viewModel.transform(input: input)
        [
            output.editingType
                .drive(editingTypeBinding),
            output.userInfoItem
                .drive(userInfoItemBinding),
            output.doneCompleted
                .emit(with: self, onNext: { owner, _ in
                    owner.navigationController?.popViewController(animated: true)
                }),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
    
    func makeInput() -> OtherItemEditingViewModel.Input {
        return .init(
            doneTrigger: completeButton.rx.tap.asSignal(),
            icon: .empty(), // TODO: 아이콘 선택 이벤트 매핑
            contents: contentsInputCell.contentsTextField.rx.text.orEmpty.asDriver()
        )
    }
    
    var editingTypeBinding: Binder<OtherItemEditingViewModel.EditingType> {
        .init(self) { vc, editingType in
            switch editingType {
            case .edit:
                vc.navigationItem.title = "항목 편집"
                vc.completeButton.title = "완료"
            case .new:
                vc.navigationItem.title = "새 항목 추가"
                vc.completeButton.title = "추가"
            }
        }
    }
    
    var userInfoItemBinding: Binder<UserInfoItem> {
        .init(self) { vc, userInfoItem in
            vc.iconInputCell.icon = userInfoItem.icon
            vc.contentsInputCell.contentsTextField.text = userInfoItem.contents
        }
    }
}

// MARK: - UITableViewDataSource

extension OtherItemEditingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return inputCells[indexPath.row]
    }
}
