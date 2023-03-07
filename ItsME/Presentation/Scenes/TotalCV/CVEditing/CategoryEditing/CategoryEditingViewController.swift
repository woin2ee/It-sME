//
//  CategoryEditingViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/03.
//

import UIKit
import Then
import SnapKit

class CategoryEditingViewController: UIViewController, UITableViewDataSource {
    
    private let viewModel: CategoryEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var categoryInputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.sectionHeaderHeight = 0
        $0.isUserInteractionEnabled = false
        let cellType = CategoryItemsCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    private lazy var periodInputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.sectionHeaderHeight = 0
        $0.isUserInteractionEnabled = false
        let cellType = PeriodCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
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
        
        configureNavigationBar()
        configureSubviews()
    }
}

// MARK: - Private Functions
extension CategoryEditingViewController {
    
    func configureNavigationBar() {
        self.navigationItem.title = "카테고리 편집"
        self.navigationItem.rightBarButtonItem = completeBarButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
    
    func configureSubviews() {
        
        let tableInset = 15
        let tableOffset = 10
        
        self.view.addSubview(periodInputTableView)
        periodInputTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(tableInset)
            make.top.equalToSuperview().offset(tableOffset)
        }
        
        self.view.addSubview(categoryInputTableView)
        categoryInputTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(tableInset)
            make.top.equalTo(periodInputTableView.snp.bottom).offset(tableOffset)
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == categoryInputTableView {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let resumeItem = viewModel
        
        if tableView == categoryInputTableView {
            
            let cell: CategoryItemsCell = .init()
            
            let placeholderArray = ["제목", "부제목", "설명"]
            cell.contentsTextField.placeholder = placeholderArray[indexPath.row]
            let contents = [resumeItem.item.title, resumeItem.item.secondTitle, resumeItem.item.description]
            cell.contentsTextField.text = contents[indexPath.row]
            return cell
        } else {
            
            let cell: PeriodCell = .init()
            let periodTitleArray = ["시작", "종료"]
            
            let periodContentsArray = [resumeItem.item.entranceDate, resumeItem.item.endDate]
            
            cell.periodLabel.text = periodTitleArray[indexPath.row]
            cell.periodTextField.text = periodContentsArray[ifExists: indexPath.row]
            
            return cell
        }
    }
}
