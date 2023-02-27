//
//  IconInputCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/14.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class IconInputCell: UITableViewCell {
    
    private let disposeBag: DisposeBag = .init()
    
    let viewModel: IconInputViewModel
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = .init().then {
        $0.text = "아이콘"
    }
    
    private lazy var iconLabel: UILabel = .init().then {
        $0.text = UserInfoItemIcon.default.toEmoji
    }
    
    // MARK: - Initializer
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, viewModel: IconInputViewModel) {
        self.viewModel = viewModel
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemBackground
        configureSubviews()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}

// MARK: - Private Functions

private extension IconInputCell {
    
    func configureSubviews() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(40).priority(999)
            make.width.equalTo(60)
        }
        
        self.contentView.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
        }
    }
    
    func bindViewModel() {
        // TODO: 아이콘 변경 이벤트 바인딩
        let input = IconInputViewModel.Input.init(newIcon: .empty())
        let output = viewModel.transform(input: input)
        
        output.currentIcon
            .map { $0.toEmoji }
            .drive(iconLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
