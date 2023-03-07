//
//  SchoolEnrollmentStatusCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/06.
//

import SnapKit
import Then
import UIKit

final class SchoolEnrollmentStatusCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = .init().then {
        $0.text = "졸업 여부"
        $0.setContentHuggingPriority(.init(rawValue: 249), for: .horizontal)
    }
    
    lazy var menuLabel: UILabel = .init().then {
        $0.text = "재학중"
        $0.textColor = .systemGray
    }
    
    private lazy var chevronImageView: UIImageView = .init().then {
        $0.image = .init(systemName: "chevron.up.chevron.down")
        $0.tintColor = .systemGray
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var wrappingButton: UIButton = .init().then {
        $0.backgroundColor = .clear
        $0.showsMenuAsPrimaryAction = true
    }
    
    var menu: UIMenu? {
        get {
            wrappingButton.menu
        }
        set {
            wrappingButton.menu = newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: selected)
    }
    
    private func configureSubviews() {
        let accessoryStackView: UIStackView = .init().then {
            $0.axis = .horizontal
            $0.spacing = 4.0
            $0.addArrangedSubview(menuLabel)
            $0.addArrangedSubview(chevronImageView)
        }
        
        let innerStackView: UIStackView = .init().then {
            $0.axis = .horizontal
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(accessoryStackView)
        }
        
        self.contentView.addSubview(innerStackView)
        innerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
        
        self.contentView.addSubview(wrappingButton)
        wrappingButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
