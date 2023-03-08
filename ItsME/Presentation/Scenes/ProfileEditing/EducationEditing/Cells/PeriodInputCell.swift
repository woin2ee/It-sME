//
//  PeriodInputCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/28.
//

import SnapKit
import Then
import UIKit

final class PeriodInputCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = .init().then {
        $0.setContentHuggingPriority(.init(rawValue: 249), for: .horizontal)
    }
    
    lazy var dateSelectionButton: UIButton = .init(configuration: .gray()).then {
        let dateFormatter: DateFormatter = .init().then {
            $0.dateFormat = "yyyy.MM"
        }
        let title = dateFormatter.string(from: .now)
        $0.setTitle(title, for: .normal)
        $0.setTitleColor(.label, for: .normal)
    }
    
    init(title: String) {
        super.init(style: .default, reuseIdentifier: nil)
        titleLabel.text = title
        configureSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    private func configureSubviews() {
        let stackView: UIStackView = .init().then {
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(dateSelectionButton)
            $0.distribution = .fill
            $0.spacing = 10.0
            $0.axis = .horizontal
            $0.alignment = .center
        }
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
    }
}
