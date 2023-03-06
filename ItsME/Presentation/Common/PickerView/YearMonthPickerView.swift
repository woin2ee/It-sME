//
//  YearMonthPickerView.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/02.
//

import UIKit

@objc protocol YearMonthPickerViewDelegate: AnyObject {
    
    /// `PickerView`의 값이 변경되었을 때 호출됩니다.
    @objc optional func yearMonthPickerViewDidSelect(year: Int, month: Int)
}

class YearMonthPickerView: UIPickerView {

    // MARK: - DataSource
    
    /// 선택할 수 있는 `year` 의 범위입니다.
    ///
    /// 기본값은 현재 년도부터 100년전까지의 범위입니다.
    var availableYears: [Int] = {
        guard let currentYear = Calendar.current.dateComponents([.year], from: .now).year else {
            #if DEBUG
            debugPrint("현재 연도를 추출하지 못했습니다. \(#file) \(#line)")
            #endif
            return []
        }
        let lastYear = currentYear - 100
        return (lastYear...currentYear).map { $0 }.reversed()
    }()
    
    /// 선택할 수 있는 `month` 의 범위입니다.
    ///
    /// 기본값은 1월~12월까지 입니다.
    var availableMonths: [Int] = (1...12).map { $0 }
    
    private var yearMonthPickerViewDataSource: [[Int]] {
        [availableYears, availableMonths]
    }
    
    // MARK: - Appearance
    
    let rowHeight: CGFloat = 35.0
    let componentWidth: CGFloat = 100.0
    
    // MARK: - Delegate
    
    weak var yearMonthPickerViewDelegate: YearMonthPickerViewDelegate?
    
    // MARK: - Initailzer
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dataSource = self
        self.delegate = self
    }
}

// MARK: - Internal Functions

extension YearMonthPickerView {
    
    /// `PickerView` 의 현재 날짜를 주어진 `year`, `month` 에 맞게 설정합니다.
    ///
    /// `PickerView` 로 선택할 수 있는 범위를 벗어난 날짜를 지정했을 경우 맨 위의 `year` 또는 `month` 로 설정됩니다.
    func setDate(year: Int, month: Int, animated: Bool) {
        let yearRow = availableYears.firstIndex(of: year) ?? 0
        let monthRow = availableMonths.firstIndex(of: month) ?? 0
        self.selectRow(yearRow, inComponent: 0, animated: animated)
        self.selectRow(monthRow, inComponent: 1, animated: animated)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension YearMonthPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        yearMonthPickerViewDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        yearMonthPickerViewDataSource[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(yearMonthPickerViewDataSource[component][row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = yearMonthPickerViewDataSource[0][self.selectedRow(inComponent: 0)]
        let month = yearMonthPickerViewDataSource[1][self.selectedRow(inComponent: 1)]
        yearMonthPickerViewDelegate?.yearMonthPickerViewDidSelect?(year: year, month: month)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        rowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        componentWidth
    }
}
