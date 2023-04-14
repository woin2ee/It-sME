//
//  CVEditViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/04/04.
//

import SnapKit
import Then
import UIKit
import RxSwift

class CVEditViewController: UIViewController {

    private let disposeBag: DisposeBag = .init()
    private let viewModel: CVEditViewModel
    
    // MARK: - UI Components
    private lazy var inputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.backgroundColor = .clear
    }
    
    var inputCell: ContentsInputCell = .init().then {
        $0.contentsTextField.placeholder = "제목을 입력하세요."
        $0.titleLabel.text = "제목"
        $0.titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        $0.contentsTextField.font = .systemFont(ofSize: 18)
    }
    
    private lazy var completeBarButton: UIBarButtonItem = .init()
    
    // MARK: - Initalizer
    init(viewModel: CVEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        configureSubviews()
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
private extension CVEditViewController {
    
    func configureSubviews() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.view.addSubview(inputTableView)
        inputTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
        }
    }
    
    func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = completeBarButton
    }
}

//MARK: - Binding ViewModel
private extension CVEditViewController {
    func bindViewModel() {
        
        let input: CVEditViewModel.Input = .init(
            cvTitle: inputCell.contentsTextField.rx.text.orEmpty.asDriver(),
            doneTrigger: completeBarButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        [ output.cvTitle
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
    
    var editingTypeBinding: Binder<CVEditViewModel.EditingType> {
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
extension CVEditViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return inputCell
    }
}
