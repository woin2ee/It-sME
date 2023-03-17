//
//  CategoryHeaderView.swift
//  ItsME
//
//  Created by MacBook Air on 2023/02/08.
//

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
    }
    
    lazy var titleTextField = UITextField().then {
        $0.isUserInteractionEnabled = false
        $0.text = "제목"
        $0.textColor = .systemBlue
        $0.delegate = self
    }
    
    lazy var addButton = UIButton().then {
        $0.setImage(.init(systemName: "plus"), for: .normal)
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
            headerContentView.layer.borderWidth = 2.0
            headerContentView.layer.cornerRadius = 10
            headerContentView.layer.masksToBounds = true
            titleTextField.isUserInteractionEnabled = true
            titleTextField.font = .systemFont(ofSize: 20, weight: .regular)
            titleTextField.returnKeyType = .done
            
            headerContentView.snp.removeConstraints()
            headerContentView.snp.makeConstraints() { make in
                make.bottom.equalToSuperview().offset(bottomOffset)
                make.top.leading.equalToSuperview()
            }
            
            titleTextField.snp.removeConstraints()
            titleTextField.snp.makeConstraints { make in
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
            
        } else {
            headerContentView.layer.borderColor = UIColor.clear.cgColor
            headerContentView.layer.borderWidth = 0
            headerContentView.layer.masksToBounds = false
            titleTextField.isUserInteractionEnabled = false
            titleTextField.clearsOnBeginEditing = false
            titleTextField.font = .systemFont(ofSize: 30, weight: .bold)
            
            addButton.removeFromSuperview()
            
            headerContentView.removeFromSuperview()
            self.contentView.addSubview(headerContentView)
            headerContentView.snp.makeConstraints { make in
                make.top.directionalHorizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().offset(bottomOffset)
            }
            titleTextField.removeFromSuperview()
            self.headerContentView.addSubview(titleTextField)
            titleTextField.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(40)
            }
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
        
        self.headerContentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}

extension CategoryHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}
