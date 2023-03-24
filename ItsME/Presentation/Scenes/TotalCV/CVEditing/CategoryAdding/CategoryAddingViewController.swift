//
//  CategoryAddingViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/15.
//

import SnapKit
import Then
import UIKit
import RxSwift

class CategoryAddingViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    private let viewModel: CategoryAddingViewModel
    
    // MARK: - UI Components
    private lazy var inputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.backgroundColor = .clear
    }
    
    var inputCell: ContentsInputCell = .init().then {
        $0.contentsTextField.placeholder = "제목을 입력하세요."
        $0.titleLabel.text = "항목"
        $0.titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        $0.contentsTextField.font = .systemFont(ofSize: 18)
    }
    
    private lazy var completeBarButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "완료", handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
//            self?.updateCategory()
        })
    }
    
    // MARK: - Initalizer
    
    init(viewModel: CategoryAddingViewModel) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputCell.contentsTextField.becomeFirstResponder()
    }
}

// MARK: - Private Functions

private extension CategoryAddingViewController {
    
    func configureSubviews() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.view.addSubview(inputTableView)
        inputTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "항목 추가"
        self.navigationItem.rightBarButtonItem = completeBarButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
    
//    func updateCategory() {
//        let categoryTitle = inputCell?.contentsTextField.text ?? ""
//        viewModel.resumeCategory[]?.title
//        viewModel.updateCategory(category)
//    }
}
//MARK: - Binding ViewModel
private extension CategoryAddingViewController {
    
    func bindViewModel() {
        
        let input: CategoryAddingViewModel.Input = .init(
            title: inputCell.contentsTextField.rx.text.orEmpty.asDriver(),
            doneTrigger: completeBarButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        [ output.title
            .drive(inputCell.contentsTextField.rx.text),
          output.doneHandler
            .emit(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }),
          output.editingType
            .drive(editingTypeBinding),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
    
    var editingTypeBinding: Binder<CategoryAddingViewModel.EditingType> {
        .init(self) { vc, editingType in
            switch editingType {
            case .edit:
                vc.navigationItem.title = "편집"
                vc.completeBarButton.title = "완료"
            case .new:
                vc.navigationItem.title = "추가"
                vc.completeBarButton.title = "추가"
            }
        }
    }
    
    
}

// MARK: - UITableViewDataSource

extension CategoryAddingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return inputCell
    }
}
