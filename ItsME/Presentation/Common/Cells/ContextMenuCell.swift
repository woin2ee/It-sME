//
//  ContextMenuCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/06.
//

import SnapKit
import Then
import UIKit

final class ContextMenuCell: UITableViewCell {
    
    // MARK: - UI Objects
    
    private lazy var titleLabel: UILabel = .init().then {
        $0.setContentHuggingPriority(.init(rawValue: 249), for: .horizontal)
    }
    
    lazy var menuTitleLabel: UILabel = .init().then {
        $0.textColor = .systemGray
    }
    
    private lazy var chevronImageView: UIImageView = .init().then {
        $0.image = .init(systemName: "chevron.up.chevron.down")
        $0.tintColor = .systemGray
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var wrappingButton: UIButton = .init().then {
        $0.backgroundColor = .clear
        $0.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - Accessible Properties
    
    /// Cell 의 Leading 방향에 표시될 타이틀입니다.
    var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    /// 셀을 터치했을때 표시될 메뉴입니다.
    var menu: [MenuElement]? = nil {
        willSet(newMenu) {
            guard let newMenu = newMenu else {
                wrappingButton.menu = nil
                menuTitleLabel.text = nil
                return
            }
            
            let menu = newMenu.map { menuElement in
                UIAction.init(title: menuElement.title) { [weak self] _ in
                    menuElement.handler?()
                    self?.menuTitleLabel.text = menuElement.title
                }
            }
            wrappingButton.menu = .init(children: menu)
            menuTitleLabel.text = newMenu.first?.title
        }
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Functions

private extension ContextMenuCell {
    
    func configureSubviews() {
        let accessoryStackView: UIStackView = .init().then {
            $0.axis = .horizontal
            $0.spacing = 4.0
            $0.alignment = .center
            $0.addArrangedSubview(menuTitleLabel)
            $0.addArrangedSubview(chevronImageView)
        }
        
        let innerStackView: UIStackView = .init().then {
            $0.axis = .horizontal
            $0.spacing = 10.0
            $0.alignment = .center
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(accessoryStackView)
        }
        
        self.contentView.addSubview(innerStackView)
        innerStackView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(10)
            make.directionalVerticalEdges.equalToSuperview().inset(5)
            let defaultHeight = 44
            make.height.equalTo(defaultHeight).priority(.high)
        }
        
        self.contentView.addSubview(wrappingButton)
        wrappingButton.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
}

// MARK: - MenuElement

extension ContextMenuCell {
    
    /// 메뉴 항목을 생성할 때 사용되는 구조체입니다.
    struct MenuElement {
        
        /// 화면에 표시되는 메뉴 항목의 타이틀입니다.
        let title: String
        
        /// 해당 메뉴가 선택되었을때 실행될 핸들러입니다.
        let handler: (() -> Void)?
        
        /// 주어진 `title` 을 가지고 터치되었을때 `handler` 를 실행하는 메뉴 항목을 생성합니다.
        /// - Parameters:
        ///   - title: `View` 에 보여질 메뉴의 타이틀입니다.
        ///   - handler: 터치되었을때 실행될 `handler` 입니다.
        init(title: String, handler: (() -> Void)?) {
            self.title = title
            self.handler = handler
        }
    }
}
