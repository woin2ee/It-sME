//
//  EducationEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/28.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class EducationEditingViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    private let viewModel: EducationEditingViewModel
    
    // MARK: UI Components
    
    private lazy var inputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .clear
    }
    
    private lazy var titleInputCell: TextFieldCell = .init().then {
        $0.textField.placeholder = "학교"
        $0.textField.autocorrectionType = .no
        $0.textField.clearButtonMode = .whileEditing
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private lazy var descriptionInputCell: TextFieldCell = .init().then {
        $0.textField.placeholder = "계열 또는 학과"
        $0.textField.autocorrectionType = .no
        $0.textField.clearButtonMode = .whileEditing
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private lazy var entranceDateInputCell: ButtonCell = .init(title: "입학일").then {
        let action: UIAction = .init { [weak self] _ in
            self?.toggleEntranceDatePickerCell()
            self?.hideGraduateDatePickerCell()
        }
        $0.trailingButton.addAction(action, for: .touchUpInside)
        $0.trailingButton.setTitleColor(.label, for: .normal)
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.selectionStyle = .none
    }
    
    private lazy var entranceDatePickerCell: YearMonthPickerCell = .init().then {
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private var entranceDatePickerCellIndexPath: IndexPath {
        .init(row: 1, section: 1)
    }
    
    private var isShowingEntranceDatePickerCell: Bool {
        inputTableViewDataSource[entranceDatePickerCellIndexPath.section].contains(entranceDatePickerCell)
    }
    
    private lazy var schoolEnrollmentStatusCell: ContextMenuCell = .init().then {
        $0.title = "졸업 여부"
        $0.menu = [
            .init(title: "재학중", handler: { [weak self] in
                self?.hideGraduateDateInputCells()
            }),
            .init(title: "졸업", handler: { [weak self] in
                self?.showGraduateDateInputCells()
            }),
        ]
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private lazy var graduateDateInputCell: ButtonCell = .init(title: "졸업일").then {
        let action: UIAction = .init { [weak self] _ in
            self?.toggleGraduateDatePickerCell()
            self?.hideEntranceDatePickerCell()
        }
        $0.trailingButton.addAction(action, for: .touchUpInside)
        $0.trailingButton.setTitleColor(.label, for: .normal)
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.selectionStyle = .none
    }
    
    private lazy var graduateDatePickerCell: YearMonthPickerCell = .init().then {
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private var graduateDatePickerCellIndexPath: IndexPath {
        let section = 1
        let row = inputTableViewDataSource[section].endIndex
        return .init(row: row, section: section)
    }
    
    private var isShowingGraduateDatePickerCell: Bool {
        inputTableViewDataSource[graduateDatePickerCellIndexPath.section].contains(graduateDatePickerCell)
    }
    
    private(set) lazy var inputTableViewDataSource: [[UITableViewCell]] = [
        [titleInputCell, descriptionInputCell],
        [entranceDateInputCell, schoolEnrollmentStatusCell]
    ]
    
    private lazy var completeButton: UIBarButtonItem = .init(title: "완료").then {
        $0.style = .done
    }
    
    private lazy var deleteButton: UIButton = .init(configuration: .bordered().with {
        $0.baseBackgroundColor = .secondarySystemGroupedBackground
        $0.baseForegroundColor = .systemRed
        $0.title = "삭제"
        $0.cornerStyle = .large
    })
    
    // MARK: Initalizer
    
    init(viewModel: EducationEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
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
    }
}

// MARK: - Private Functions

private extension EducationEditingViewController {
    
    func configureSubviews() {
        self.view.addSubview(inputTableView)
        inputTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(inputTableView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = completeButton
    }
    
    func toggleEntranceDatePickerCell() {
        if isShowingEntranceDatePickerCell {
            hideEntranceDatePickerCell()
        } else {
            showEntranceDatePickerCell()
        }
    }
    
    func hideEntranceDatePickerCell(withDuration duration: TimeInterval = 0.3) {
        if isShowingEntranceDatePickerCell {
            let indexPath = entranceDatePickerCellIndexPath
            UIView.animate(withDuration: duration, animations: {
                self.inputTableViewDataSource[indexPath.section].removeAll { $0 === self.entranceDatePickerCell }
                self.inputTableView.deleteRows(at: [indexPath], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func showEntranceDatePickerCell(withDuration duration: TimeInterval = 0.3) {
        if !isShowingEntranceDatePickerCell {
            let indexPath = entranceDatePickerCellIndexPath
            UIView.animate(withDuration: duration, animations: {
                self.inputTableViewDataSource[indexPath.section].insert(self.entranceDatePickerCell, at: indexPath.row)
                self.inputTableView.insertRows(at: [indexPath], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func toggleGraduateDatePickerCell() {
        if isShowingGraduateDatePickerCell {
            hideGraduateDatePickerCell()
        } else {
            showGraduateDatePickerCell()
        }
    }
    
    func hideGraduateDatePickerCell(withDuration duration: TimeInterval = 0.3) {
        if isShowingGraduateDatePickerCell {
            let indexPath = graduateDatePickerCellIndexPath
            UIView.animate(withDuration: duration, animations: {
                self.inputTableViewDataSource[indexPath.section].removeAll { $0 === self.graduateDatePickerCell }
                self.inputTableView.deleteRows(at: [.init(row: indexPath.row - 1, section: indexPath.section)], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func showGraduateDatePickerCell(withDuration duration: TimeInterval = 0.3) {
        if !isShowingGraduateDatePickerCell {
            let indexPath = graduateDatePickerCellIndexPath
            UIView.animate(withDuration: duration, animations: {
                self.inputTableViewDataSource[indexPath.section].insert(self.graduateDatePickerCell, at: indexPath.row)
                self.inputTableView.insertRows(at: [indexPath], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc dynamic func hideGraduateDateInputCells() {
        inputTableView.beginUpdates()
        defer { inputTableView.endUpdates() }
        
        let section = 1
        let graduateDateInputCellRow = inputTableViewDataSource[section].firstIndex(of: graduateDateInputCell)
        let graduateDatePickerCellRow = inputTableViewDataSource[section].firstIndex(of: graduateDatePickerCell)
        
        if let row = graduateDateInputCellRow {
            inputTableViewDataSource[section].removeAll(where: { $0 === graduateDateInputCell })
            inputTableView.deleteRows(at: [.init(row: row, section: section)], with: .fade)
        }
        if let row = graduateDatePickerCellRow {
            inputTableViewDataSource[section].removeAll(where: { $0 === graduateDatePickerCell })
            inputTableView.deleteRows(at: [.init(row: row, section: section)], with: .fade)
        }
    }
    
    @objc dynamic func showGraduateDateInputCells() {
        let section = 1
        if inputTableViewDataSource[section].contains(graduateDateInputCell) { return }
        
        if let row = inputTableViewDataSource[section].firstIndex(of: schoolEnrollmentStatusCell) {
            let nextRow = row + 1
            inputTableViewDataSource[section].insert(graduateDateInputCell, at: nextRow)
            inputTableView.insertRows(at: [.init(row: nextRow, section: section)], with: .fade)
        }
    }
}

// MARK: - Binding ViewModel

private extension EducationEditingViewController {
    
    func bindViewModel() {
        let input: EducationEditingViewModel.Input = .init(
            title: titleInputCell.textField.rx.text.orEmpty.asDriver(),
            description: descriptionInputCell.textField.rx.text.orEmpty.asDriver(),
            entranceDate: entranceDatePickerCell.yearMonthPickerView.rx.dateSelected.asDriver(),
            graduateDate: graduateDatePickerCell.yearMonthPickerView.rx.dateSelected.asDriver(),
            doneTrigger: completeButton.rx.tap.asSignal(),
            enrollmentSelection: self.rx.methodInvoked(#selector(hideGraduateDateInputCells))
                .mapToVoid()
                .asDriverOnErrorJustComplete(),
            graduateSelection: self.rx.methodInvoked(#selector(showGraduateDateInputCells))
                .mapToVoid()
                .asDriverOnErrorJustComplete(),
            deleteTrigger: deleteButton.rx.tap.flatMapFirst {
                self.rx.presentConfirmAlert(
                    title: "항목 삭제",
                    message: "학력 정보를 삭제하시겠습니까?",
                    okAction: UIAlertAction(title: "삭제", style: .destructive)
                )
            }.asSignalOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        [
            output.educationItem
                .drive(educationItemBinding),
            output.doneHandler
                .emit(with: self, onNext: { owner, _ in
                    owner.navigationController?.popViewController(animated: true)
                }),
            output.editingType
                .drive(editingTypeBinding),
            output.deleteHandler
                .emit(with: self, onNext: { owner, _ in
                    owner.navigationController?.popViewController(animated: true)
                }),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
    
    var educationItemBinding: Binder<EducationItem> {
        .init(self) { vc, educationItem in
            vc.titleInputCell.textField.text = educationItem.title
            vc.descriptionInputCell.textField.text = educationItem.description
            vc.entranceDateInputCell.trailingButton.setTitle(educationItem.entranceDate, for: .normal)
            vc.entranceDatePickerCell.yearMonthPickerView.setDate(year: educationItem.entranceYear ?? 0, month: educationItem.entranceMonth ?? 0, animated: false)
            vc.graduateDateInputCell.trailingButton.setTitle(educationItem.graduateDate, for: .normal)
            vc.graduateDatePickerCell.yearMonthPickerView.setDate(year: educationItem.graduateYear ?? 0, month: educationItem.graduateMonth ?? 0, animated: false)
        }
    }
    
    var editingTypeBinding: Binder<EducationEditingViewModel.EditingType> {
        .init(self) { vc, editingType in
            switch editingType {
            case .edit:
                vc.navigationItem.title = "학력 편집"
                vc.completeButton.title = "완료"
                vc.deleteButton.isHidden = false
            case .new:
                vc.navigationItem.title = "학력 추가"
                vc.completeButton.title = "추가"
                vc.deleteButton.isHidden = true
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension EducationEditingViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        let commonHeightCells = [entranceDateInputCell, schoolEnrollmentStatusCell, graduateDateInputCell]
        if commonHeightCells.contains(inputTableViewDataSource[indexPath.section][indexPath.row]) {
            return 44
        }
        return UITableView.automaticDimension
    }
}
