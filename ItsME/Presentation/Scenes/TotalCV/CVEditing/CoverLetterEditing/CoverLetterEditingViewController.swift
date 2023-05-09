//
//  CoverLetterEditingViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/03.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class CoverLetterEditingViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    private let viewModel: CoverLetterEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var coverLetterEditTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.sectionHeaderHeight = 0
    }
    
    private lazy var coverLetterTitleCell: CoverLetterTitleCell = .init().then {
        $0.titleTextField.placeholder = "제목"
        $0.titleTextField.autocorrectionType = .no
        $0.titleTextField.clearButtonMode = .whileEditing
        $0.titleTextField.returnKeyType = .continue
        $0.titleTextField.keyboardType = .default
        $0.titleTextField.delegate = self
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.selectionStyle = .none
    }
    
    private lazy var coverLetterContentCell: CoverLetterContentCell = .init().then {
        $0.content.placeholder = "설명을 입력하세요."
        $0.content.placeholderColor = .placeholderText
        $0.content.autocorrectionType = .no
        $0.content.backgroundColor = .clear
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.selectionStyle = .none
    }
    
    private(set) lazy var inputTableViewDataSource: [UITableViewCell] = [
        coverLetterTitleCell, coverLetterContentCell
    ]
    
    private lazy var completeBarButton: UIBarButtonItem = .init()
    
    var coverLetterItemCell: CoverLetterTitleCell? {
        coverLetterEditTableView.visibleCells[ifExists: 0] as? CoverLetterTitleCell
    }
    
    // MARK: - Initializer
    init(viewModel: CoverLetterEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        configureNavigationBar()
        configureSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coverLetterItemCell?.titleTextField.becomeFirstResponder()
    }
}

//MARK: - Private Function
extension CoverLetterEditingViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .systemGroupedBackground
    }
    
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = completeBarButton
    }
    
    func configureSubviews() {
        
        self.view.addSubview(coverLetterEditTableView)
        coverLetterEditTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
}

//MARK: - Binding ViewModel
private extension CoverLetterEditingViewController {
    
    func bindViewModel() {
        
        let input: CoverLetterEditingViewModel.Input = .init(
            title: coverLetterTitleCell.titleTextField.rx.text.orEmpty.asDriver(),
            content: coverLetterContentCell.content.rx.text.orEmpty.asDriver(),
            doneTrigger: completeBarButton.rx.tap.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        [
            output.coverLetterItem
                .drive(coverLetterItemBinding),
            output.coverLetterItem
                .map(\.title.isNotEmpty)
                .drive(completeBarButton.rx.isEnabled),
            output.doneHandler
                .emit(with: self, onNext: { owner, _ in
                    owner.navigationController?.popViewController(animated: true)
                }),
            output.editingType
                .drive(editingTypeBinding),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
    
    var coverLetterItemBinding: Binder<CoverLetterItem> {
        .init(self) { vc, coverLetterItem in
            vc.coverLetterTitleCell.titleTextField.text = coverLetterItem.title
            vc.coverLetterContentCell.content.text = coverLetterItem.contents
        }
    }
    
    var editingTypeBinding: Binder<CoverLetterEditingViewModel.EditingType> {
        .init(self) { vc, editingType in
            switch editingType {
            case .edit:
                vc.navigationItem.title = "자기소개서 편집"
                vc.completeBarButton.title = "완료"
            case .new:
                vc.navigationItem.title = "자기소개서 추가"
                vc.completeBarButton.title = "추가"
            }
        }
    }
}

//MARK: - TableView
extension CoverLetterEditingViewController :UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputTableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return inputTableViewDataSource[indexPath.row]
    }
}

//MARK: - Delgate
extension CoverLetterEditingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == coverLetterTitleCell.titleTextField {
            coverLetterContentCell.content.becomeFirstResponder()
        }
        return true
    }
}
