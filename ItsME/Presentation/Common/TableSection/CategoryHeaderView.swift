//
//  CategoryHeaderView.swift
//  ItsME
//
//  Created by MacBook Air on 2023/02/08.
//

import SFSafeSymbols
import SnapKit
import Then
import UIKit

class CategoryHeaderView: UITableViewHeaderFooterView {
    
    var isEditingMode: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    private let buttonWidth = 35
    private let buttonHeight = 35
    private let bottomOffset = -10
    private let verticalEdgesInset = 7
    private let horizontalEdgesInset = 10
    static let reuseIdentifier: String = .init(describing: CategoryHeaderView.self)
    
    //MARK: - UI Component
    lazy var headerContentView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 2.0
    }
    
    lazy var titleButton = UIButton().then {
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.isUserInteractionEnabled = false
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    }
    
    lazy var editButton = UIImageView().then {
        $0.image = UIImage(systemSymbol: .rectangleAndPencilAndEllipsis)
    }
    
    lazy var addButton = UIButton().then {
        $0.setImage(.init(systemSymbol: .plus), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("awakeFromNib() has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.configureSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isEditingMode {
            headerContentView.layer.borderColor = UIColor.tertiaryLabel.cgColor
            headerContentView.layer.masksToBounds = true
            titleButton.isUserInteractionEnabled = true
            
            editMode()
        } else {
            headerContentView.layer.borderColor = UIColor.clear.cgColor
            headerContentView.layer.masksToBounds = false
            titleButton.isUserInteractionEnabled = false
            
            viewMode()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func doneButtonAction() {
        endEditing(true)
    }
}

// MARK: - Private Functions
private extension CategoryHeaderView {
    
    func configureSubviews() {
        self.contentView.addSubview(headerContentView)
        headerContentView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(bottomOffset)
        }
        
        self.headerContentView.addSubview(titleButton)
        titleButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func editMode() {
        headerContentView.snp.removeConstraints()
        headerContentView.snp.makeConstraints() { make in
            make.bottom.equalToSuperview().offset(bottomOffset)
            make.top.leading.equalToSuperview()
        }
        
        self.titleButton.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(buttonWidth)
            make.trailing.equalToSuperview()
        }
        
        titleButton.snp.removeConstraints()
        titleButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(verticalEdgesInset)
            make.horizontalEdges.equalToSuperview().inset(horizontalEdgesInset)
        }
        
        
        
        self.contentView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(headerContentView.snp.trailing)
            make.trailing.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.width.equalTo(buttonWidth)
        }
    }
    
    func viewMode() {
        addButton.removeFromSuperview()
        titleButton.removeFromSuperview()
        headerContentView.removeFromSuperview()
        editButton.removeFromSuperview()
        
        configureSubviews()
    }
}
