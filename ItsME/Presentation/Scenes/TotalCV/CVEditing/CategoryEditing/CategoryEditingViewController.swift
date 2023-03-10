//
//  CategoryEditingViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/03.
//

import UIKit
import Then
import SnapKit

final class CategoryEditingViewController: UIViewController {
    
    private let viewModel: CategoryEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var categoryInputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.sectionHeaderHeight = 0
    }
    
    private lazy var periodInputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.sectionHeaderHeight = 0
    }
    
    var categoryItemsCell: CategoryItemsCell? {
        categoryInputTableView.visibleCells[ifExists: 0] as? CategoryItemsCell
    }
    
    var periodCell: PeriodCell? {
        periodInputTableView.visibleCells[ifExists: 0] as? PeriodCell
    }
    
    private lazy var completeBarButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "완료", handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
    }
    
    // MARK: - Initializer
    
    init(viewModel: CategoryEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        configureNavigationBar()
        configureSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        categoryItemsCell?.contentsTextField.becomeFirstResponder()
    }
}

//MARK: - Private Function
private extension CategoryEditingViewController {
    func configureAppearance() {
        self.view.backgroundColor = .systemGroupedBackground
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "카테고리 편집"
        self.navigationItem.rightBarButtonItem = completeBarButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
    
    func configureSubviews() {
        
        let tableInset = 15
        let tableOffset = 50
        
        self.view.addSubview(periodInputTableView)
        periodInputTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(tableInset)
            make.top.equalToSuperview().offset(tableOffset)
        }
        
        self.view.addSubview(categoryInputTableView)
        categoryInputTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(tableInset)
            make.top.equalTo(periodInputTableView.snp.bottom).offset(-tableOffset)
            
        }
    }
}

// MARK: - TableView
extension CategoryEditingViewController: UITableViewDataSource, UITextFieldDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == categoryInputTableView {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == categoryInputTableView {
            
            let cell: CategoryItemsCell = .init()
            
            cell.contentsTextField.delegate = self
            
            let placeholderArray = ["제목", "부제목", "설명"]
            cell.contentsTextField.placeholder = placeholderArray[indexPath.row]
            
            if indexPath.row == 2 {
                cell.contentsTextField.removeFromSuperview()
                
                lazy var contentTextView: UITextView = .init().then {
                    $0.layer.cornerRadius = 10
                    $0.layer.masksToBounds = true
                    $0.isUserInteractionEnabled = true
                    $0.allowsEditingTextAttributes = true
                    $0.backgroundColor = .systemGray5
                    $0.textColor = .label
                    $0.text = viewModel.resumeItem.description
                    $0.font = .systemFont(ofSize: 15, weight: .regular)
                    $0.autocorrectionType = .no
                    $0.autocapitalizationType = .none
                }
                
                cell.contentView.addSubview(contentTextView)
                contentTextView.snp.makeConstraints { make in
                    make.leading.trailing.top.bottom.equalToSuperview().inset(15)
                    make.height.equalTo(150)
                }
                
            } else {
                let contents = [viewModel.resumeItem.title, viewModel.resumeItem.secondTitle]
                cell.contentsTextField.text = contents[indexPath.row]
            }
            
            return cell
        } else {
            let periodTitleArray = ["시작", "종료"]
            let cell: PeriodCell = .init(title: periodTitleArray[indexPath.row])
            
            return cell
        }
    }
}
