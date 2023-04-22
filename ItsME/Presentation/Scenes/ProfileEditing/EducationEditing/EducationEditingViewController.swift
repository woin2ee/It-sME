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
    
    private lazy var containerScrollView: UIScrollView = .init().then {
        $0.backgroundColor = .clear
    }
    
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
                self?.tapEnrolledMenu()
            }),
            .init(title: "졸업", handler: { [weak self] in
                self?.tapGraduatedMenu()
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
        $0.baseBackgroundColor = .systemRed
        $0.baseForegroundColor = .white
        let attributeContainer: AttributeContainer = .init(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .bold)]
        )
        $0.attributedTitle = .init("삭제", attributes: attributeContainer)
        $0.cornerStyle = .large
        $0.image = .init(systemName: "trash.fill")
        $0.imagePadding = 2
        $0.preferredSymbolConfigurationForImage = .init(scale: .medium)
    })
    
    // MARK: Initalizer
    
    init(viewModel: EducationEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
        bindNotificationsForKeyboard()
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

// MARK: - Methods

extension EducationEditingViewController {
    
    private func configureSubviews() {
        self.view.addSubview(containerScrollView)
        containerScrollView.addSubview(inputTableView)
        containerScrollView.addSubview(deleteButton)
        
        containerScrollView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        inputTableView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
            make.width.equalTo(self.view.safeAreaLayoutGuide)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(inputTableView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigationBar() {
        self.navigationItem.rightBarButtonItem = completeButton
    }
    
    private func toggleEntranceDatePickerCell() {
        if isShowingEntranceDatePickerCell {
            hideEntranceDatePickerCell()
        } else {
            showEntranceDatePickerCell()
        }
    }
    
    private func hideEntranceDatePickerCell(withDuration duration: TimeInterval = 0.3) {
        if isShowingEntranceDatePickerCell {
            let indexPath = entranceDatePickerCellIndexPath
            UIView.animate(withDuration: duration, animations: {
                self.inputTableViewDataSource[indexPath.section].removeAll { $0 === self.entranceDatePickerCell }
                self.inputTableView.deleteRows(at: [indexPath], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func showEntranceDatePickerCell(withDuration duration: TimeInterval = 0.3) {
        if !isShowingEntranceDatePickerCell {
            let indexPath = entranceDatePickerCellIndexPath
            UIView.animate(withDuration: duration, animations: {
                self.inputTableViewDataSource[indexPath.section].insert(self.entranceDatePickerCell, at: indexPath.row)
                self.inputTableView.insertRows(at: [indexPath], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func toggleGraduateDatePickerCell() {
        if isShowingGraduateDatePickerCell {
            hideGraduateDatePickerCell()
        } else {
            showGraduateDatePickerCell()
        }
    }
    
    private func hideGraduateDatePickerCell(withDuration duration: TimeInterval = 0.3) {
        if isShowingGraduateDatePickerCell {
            let indexPath = graduateDatePickerCellIndexPath
            UIView.animate(withDuration: duration, animations: {
                self.inputTableViewDataSource[indexPath.section].removeAll { $0 === self.graduateDatePickerCell }
                self.inputTableView.deleteRows(at: [.init(row: indexPath.row - 1, section: indexPath.section)], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func showGraduateDatePickerCell(withDuration duration: TimeInterval = 0.3) {
        if !isShowingGraduateDatePickerCell {
            let indexPath = graduateDatePickerCellIndexPath
            UIView.animate(withDuration: duration, animations: {
                self.inputTableViewDataSource[indexPath.section].insert(self.graduateDatePickerCell, at: indexPath.row)
                self.inputTableView.insertRows(at: [indexPath], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func hideGraduateDateInputCells() {
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
    
    private func showGraduateDateInputCells() {
        let section = 1
        if inputTableViewDataSource[section].contains(graduateDateInputCell) { return }
        
        if let row = inputTableViewDataSource[section].firstIndex(of: schoolEnrollmentStatusCell) {
            let nextRow = row + 1
            inputTableViewDataSource[section].insert(graduateDateInputCell, at: nextRow)
            inputTableView.insertRows(at: [.init(row: nextRow, section: section)], with: .fade)
        }
    }
    
    @objc dynamic private func tapEnrolledMenu() {
        self.hideGraduateDateInputCells()
    }
    
    @objc dynamic private func tapGraduatedMenu() {
        self.showGraduateDateInputCells()
    }
}

// MARK: - Binding ViewModel

extension EducationEditingViewController {
    
    private func bindViewModel() {
        let input: EducationEditingViewModel.Input = makeInput()
        let output = viewModel.transform(input: input)
        [
            output.title
                .drive(titleInputCell.textField.rx.text),
            output.description
                .drive(descriptionInputCell.textField.rx.text),
            output.entranceDate
                .drive(with: self, onNext: { owner, date in
                    let dateString = "\(date.year).\(date.month.toLeadingZero(digit: 2))"
                    owner.entranceDateInputCell.trailingButton.setTitle(dateString, for: .normal)
                    owner.entranceDatePickerCell.yearMonthPickerView.setDate(year: date.year, month: date.month, animated: false)
                }),
            output.graduateDate
                .drive(with: self, onNext: { owner, date in
                    let dateString = "\(date.year).\(date.month.toLeadingZero(digit: 2))"
                    owner.graduateDateInputCell.trailingButton.setTitle(dateString, for: .normal)
                    owner.graduateDatePickerCell.yearMonthPickerView.setDate(year: date.year, month: date.month, animated: false)
                }),
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
            output.schoolEnrollmentStatus
                .drive(schoolEnrollmentStatusBinding),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
    
    private func makeInput() -> EducationEditingViewModel.Input {
        return .init(
            title: titleInputCell.textField.rx.text.orEmpty.asDriver(),
            description: descriptionInputCell.textField.rx.text.orEmpty.asDriver(),
            selectedEntranceDate: entranceDatePickerCell.yearMonthPickerView.rx.selectedDate.asDriver(),
            selectedGraduateDate: graduateDatePickerCell.yearMonthPickerView.rx.selectedDate.asDriver(),
            doneTrigger: completeButton.rx.tap.asSignal(),
            deleteTrigger: deleteButton.rx.tap.asSignal().flatMapFirst { [weak self] in
                guard let self = self else { return .empty() }
                return self.rx.presentConfirmAlert(
                    title: "항목 삭제",
                    message: "학력 정보를 삭제하시겠습니까?",
                    okAction: UIAlertAction(title: "삭제", style: .destructive)
                ).asSignal()
            },
            selectedEnrollmentStatus: .merge(
                self.rx.methodInvoked(#selector(tapEnrolledMenu))
                    .map { _ in SchoolEnrollmentStatus.enrolled }
                    .asDriverOnErrorJustComplete(),
                self.rx.methodInvoked(#selector(tapGraduatedMenu))
                    .map { _ in SchoolEnrollmentStatus.graduated }
                    .asDriverOnErrorJustComplete()
            )
        )
    }
    
    private var editingTypeBinding: Binder<EducationEditingViewModel.EditingType> {
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
    
    private var schoolEnrollmentStatusBinding: Binder<SchoolEnrollmentStatus> {
        return .init(self) { vc, status in
            switch status {
            case .enrolled:
                vc.schoolEnrollmentStatusCell.menuTitleLabel.text = SchoolEnrollmentStatus.enrolled.rawValue
                vc.hideGraduateDateInputCells()
            case .graduated:
                vc.schoolEnrollmentStatusCell.menuTitleLabel.text = SchoolEnrollmentStatus.graduated.rawValue
                vc.showGraduateDateInputCells()
            }
        }
    }
}

// MARK: - Bind Nofiticaions

extension EducationEditingViewController {
    
    private func bindNotificationsForKeyboard() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .bind(to: keyboardWillShowBinder)
            .disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .bind(to: keyboardWillHideBinder)
            .disposed(by: disposeBag)
    }
    
    private var keyboardWillShowBinder: Binder<Notification> {
        return .init(self) { vc, notification in
            guard
                let userInfo = notification.userInfo,
                let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height,
                let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)
            else { return }
            
            let spacing: CGFloat = 20
            
            UIView.animate(withDuration: keyboardAnimationDuration) {
                self.containerScrollView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().inset(keyboardHeight + spacing)
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private var keyboardWillHideBinder: Binder<Notification> {
        return .init(self) { vc, notification in
            guard
                let userInfo = notification.userInfo,
                let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval)
            else { return }
            
            UIView.animate(withDuration: keyboardAnimationDuration) {
                self.containerScrollView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().inset(0)
                }
                self.view.layoutIfNeeded()
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
