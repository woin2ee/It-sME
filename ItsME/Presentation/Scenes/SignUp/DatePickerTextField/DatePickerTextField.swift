//
//  DatePickerTextField.swift
//  ItsME
//
//  Created by MacBook Air on 2023/04/28.
//

import UIKit
import Then
import SFSafeSymbols
import SnapKit

class DatePickerTextField: UITextField {

    private lazy var buttonIcon: UIImageView = .init(image: UIImage(systemSymbol: .chevronDown))

    private lazy var datePicker: UIDatePicker = .init().then {
        $0.contentHorizontalAlignment = .leading
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.maximumDate = .now
        $0.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    private lazy var inputAccessoryBackgroundView: UIView = .init(frame: .init(x: .zero, y: .zero, width: UIScreen.main.bounds.width, height: 44.0)).then {
        $0.backgroundColor = .systemGray4
    }
    private lazy var doneButton: UIButton = .init().then {
        $0.setTitle("완료", for: .normal)
        $0.contentHorizontalAlignment = .right
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Initiallizer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetViews
extension DatePickerTextField {

    func setViews() {
        self.inputAccessoryBackgroundView.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.left.verticalEdges.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }

        rightView = buttonIcon
        rightViewMode = .always
        inputAccessoryView = inputAccessoryBackgroundView
    }
}
// MARK: - Selector
extension DatePickerTextField {
    @objc private func datePickerValueChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        text = formatter.string(from: datePicker.date)
    }
    @objc private func doneButtonTapped() {
        resignFirstResponder()
    }
}
// MARK: - Delegate
extension DatePickerTextField: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        inputView = datePicker
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
