//
//  ResumeItemEditingViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/03.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class ResumeItemEditingViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    private let viewModel: ResumeItemEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var inputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.delegate = self
        $0.keyboardDismissMode = .interactive
        $0.backgroundColor = .clear
    }
    
    private lazy var firstTitleInputCell: TextFieldCell = .init().then {
        $0.textField.placeholder = "제목"
        $0.textField.clearButtonMode = .whileEditing
        $0.textField.delegate = self
        $0.textField.keyboardType = .default
        $0.textField.returnKeyType = .continue
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.selectionStyle = .none
    }
    
    private lazy var secondTitleInputCell: TextFieldCell = .init().then {
        $0.textField.placeholder = "부제목"
        $0.textField.clearButtonMode = .whileEditing
        $0.textField.delegate = self
        $0.textField.keyboardType = .default
        $0.textField.returnKeyType = .continue
        $0.textField.autocorrectionType = .no
        $0.textField.autocapitalizationType = .none
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.selectionStyle = .none
    }
    
    private lazy var descriptionInputCell: TextViewCell = .init().then {
        $0.textView.placeholder = "설명을 입력하세요."
        $0.textView.placeholderColor = .placeholderText
        $0.textViewHeight = 120
        $0.textView.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textView.backgroundColor = .clear
        $0.textView.layer.cornerRadius = 10
        $0.textView.layer.masksToBounds = true
        $0.textView.isUserInteractionEnabled = true
        $0.textView.allowsEditingTextAttributes = true
        $0.textView.keyboardType = .default
        $0.textView.autocorrectionType = .no
        $0.textView.autocapitalizationType = .none
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.selectionStyle = .none
    }
    
    private lazy var entranceDateInputCell: ButtonCell = .init(title: "시작일").then {
        let action: UIAction = .init { [weak self] _ in
            self?.toggleEntranceDatePickerCell()
        }
        $0.trailingButton.addAction(action, for: .touchUpInside)
        $0.trailingButton.setTitleColor(.label, for: .normal)
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.selectionStyle = .none
    }
    
    private lazy var entranceDatePickerCell: YearMonthPickerCell = .init().then {
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private lazy var endOrNotEnrollmentStatusCell: ContextMenuCell = .init().then {
        $0.title = "종료 여부"
        $0.menu = [
            .init(title: "진행중", handler: { [weak self] in
                self?.hideEndDateInputCells()
            }),
            .init(title: "종료", handler: { [weak self] in
                self?.showEndDateInputCells()
            }),
        ]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contextMenuCellTapped))
        $0.wrappingButton.addGestureRecognizer(tapGesture)
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private lazy var endDateInputCell: ButtonCell = .init(title: "종료일").then {
        let action: UIAction = .init { [weak self] _ in
            self?.toggleEndDatePickerCell()
        }
        $0.trailingButton.addAction(action, for: .touchUpInside)
        $0.trailingButton.setTitleColor(.label, for: .normal)
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.selectionStyle = .none
    }
    
    private lazy var endDatePickerCell: YearMonthPickerCell = .init().then {
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private(set) lazy var inputTableViewDataSource: [[UITableViewCell]] = [
        [firstTitleInputCell, secondTitleInputCell, descriptionInputCell],
        [entranceDateInputCell, endOrNotEnrollmentStatusCell]
    ]
    
    private lazy var completeBarButton: UIBarButtonItem = .init(title: "완료").then {
        $0.style = .done
    }
    
    // MARK: - Initializer
    
    init(viewModel: ResumeItemEditingViewModel) {
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
        self.view.backgroundColor = .systemGroupedBackground
        configureSubviews()
        configureNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstTitleInputCell.textField.becomeFirstResponder()
    }
}

//MARK: - Private Function
private extension ResumeItemEditingViewController {
    
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = completeBarButton
    }
    
    func configureSubviews() {
        let containerScrollView: UIScrollView = .init().then {
            $0.backgroundColor = .clear
            $0.delegate = self
        }
        self.view.addSubview(containerScrollView)
        containerScrollView.addSubview(inputTableView)
        
        containerScrollView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        inputTableView.snp.makeConstraints { make in
            make.directionalEdges.width.equalToSuperview()
        }
    }
    
    func toggleEntranceDatePickerCell() {
        self.view.endEditing(true)
        let section = 1
        let row = 1
        let indexPath: IndexPath = .init(row: row, section: section)
        let animationDuration: TimeInterval = 0.3
        let isShowingDatePickerCell: Bool = inputTableViewDataSource[section].contains(entranceDatePickerCell)
        if isShowingDatePickerCell {
            UIView.animate(withDuration: animationDuration, animations: {
                self.inputTableViewDataSource[section].removeAll { $0 === self.entranceDatePickerCell }
                self.inputTableView.deleteRows(at: [indexPath], with: .fade)
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                self.inputTableViewDataSource[section].insert(self.entranceDatePickerCell, at: row)
                self.inputTableView.insertRows(at: [indexPath], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func toggleEndDatePickerCell() {
        self.view.endEditing(true)
        let section = 1
        let row = inputTableViewDataSource[section].endIndex
        let animationDuration: TimeInterval = 0.3
        let isShowingDatePickerCell: Bool = inputTableViewDataSource[section].contains(endDatePickerCell)
        if isShowingDatePickerCell {
            UIView.animate(withDuration: animationDuration, animations: {
                self.inputTableViewDataSource[section].removeAll { $0 === self.endDatePickerCell }
                self.inputTableView.deleteRows(at: [.init(row: row - 1, section: section)], with: .fade)
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                self.inputTableViewDataSource[section].insert(self.endDatePickerCell, at: row)
                self.inputTableView.insertRows(at: [.init(row: row, section: section)], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc dynamic func hideEndDateInputCells() {
        inputTableView.beginUpdates()
        defer { inputTableView.endUpdates() }
        
        let section = 1
        let graduateDateInputCellRow = inputTableViewDataSource[section].firstIndex(of: endDateInputCell)
        let graduateDatePickerCellRow = inputTableViewDataSource[section].firstIndex(of: endDatePickerCell)
        
        if let row = graduateDateInputCellRow {
            inputTableViewDataSource[section].removeAll(where: { $0 === endDateInputCell })
            inputTableView.deleteRows(at: [.init(row: row, section: section)], with: .fade)
        }
        if let row = graduateDatePickerCellRow {
            inputTableViewDataSource[section].removeAll(where: { $0 === endDatePickerCell })
            inputTableView.deleteRows(at: [.init(row: row, section: section)], with: .fade)
        }
    }
    
    @objc dynamic func showEndDateInputCells() {
        let section = 1
        if inputTableViewDataSource[section].contains(endDateInputCell) { return }
        
        if let row = inputTableViewDataSource[section].firstIndex(of: endOrNotEnrollmentStatusCell) {
            let nextRow = row + 1
            inputTableViewDataSource[section].insert(endDateInputCell, at: nextRow)
            inputTableView.insertRows(at: [.init(row: nextRow, section: section)], with: .fade)
        }
    }
    
    @objc private func contextMenuCellTapped() {
        self.view.endEditing(true)
    }
}

//MARK: - Binding ViewModel
private extension ResumeItemEditingViewController {
    
    func bindViewModel() {
        
        let input: ResumeItemEditingViewModel.Input = .init(
            title: firstTitleInputCell.textField.rx.text.orEmpty.asDriver(),
            secondTitle: secondTitleInputCell.textField.rx.text.orEmpty.asDriver(),
            description: descriptionInputCell.textView.rx.text.orEmpty.asDriver(),
            entranceDate: entranceDatePickerCell.yearMonthPickerView.rx.selectedDate.asDriver(),
            endDate: endDatePickerCell.yearMonthPickerView.rx.selectedDate.asDriver(),
            doneTrigger: completeBarButton.rx.tap.asSignal(),
            enrollmentSelection: self.rx.methodInvoked(#selector(hideEndDateInputCells))
                .mapToVoid()
                .asDriverOnErrorJustComplete(),
            endSelection: self.rx.methodInvoked(#selector(showEndDateInputCells))
                .mapToVoid()
                .asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        [
            output.resumeItem
                .drive(resumeItemBinding),
            output.resumeItem
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
    
    var resumeItemBinding: Binder<ResumeItem> {
        .init(self) { vc, resumeItem in
            vc.firstTitleInputCell.textField.text = resumeItem.title
            vc.secondTitleInputCell.textField.text = resumeItem.secondTitle
            vc.descriptionInputCell.textView.text = resumeItem.description
            vc.entranceDateInputCell.trailingButton.setTitle(resumeItem.entranceDate, for: .normal)
            vc.entranceDatePickerCell.yearMonthPickerView.setDate(year: resumeItem.entranceYear ?? 0, month: resumeItem.entranceMonth ?? 0, animated: false)
            vc.endDateInputCell.trailingButton.setTitle(resumeItem.endDate, for: .normal)
            vc.endDatePickerCell.yearMonthPickerView.setDate(year: resumeItem.endYear ?? 0, month: resumeItem.endMonth ?? 0, animated: false)
        }
    }
    
    var editingTypeBinding: Binder<ResumeItemEditingViewModel.EditingType> {
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

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ResumeItemEditingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        inputTableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inputTableViewDataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return inputTableViewDataSource[indexPath.section][indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let commonHeightCells = [entranceDateInputCell, endOrNotEnrollmentStatusCell, endDateInputCell]
        if commonHeightCells.contains(inputTableViewDataSource[indexPath.section][indexPath.row]) {
            return 44
        }
        return UITableView.automaticDimension
    }
}

// MARK: - UITextFieldDelegate, UITextViewDelegate

extension ResumeItemEditingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstTitleInputCell.textField {
            secondTitleInputCell.textField.becomeFirstResponder()
        }
        else if textField == secondTitleInputCell.textField {
            descriptionInputCell.textView.becomeFirstResponder()
        }
        return true
    }
}

// MARK: - UIScrollViewDelegate

extension ResumeItemEditingViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
