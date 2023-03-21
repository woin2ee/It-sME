//
//  CategoryAddingViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/15.
//

import SnapKit
import Then
import UIKit

class CategoryAddingViewController: UIViewController {
    
    private let viewModel: TotalCVViewModel
    
    // MARK: - UI Components
    private lazy var inputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.backgroundColor = .clear
    }
    
    var inputCell: ContentsInputCell? {
        inputTableView.visibleCells[ifExists: 0] as? ContentsInputCell
    }
    
    private lazy var completeBarButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "완료", handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
//            self?.updateCategory()
        })
    }
    
    // MARK: - Initalizer
    
    init(viewModel: TotalCVViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        configureSubviews()
        configureNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputCell?.contentsTextField.becomeFirstResponder()
    }
}

// MARK: - Private Functions

private extension CategoryAddingViewController {
    
    func configureSubviews() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.view.addSubview(inputTableView)
        inputTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "카테고리 추가"
        self.navigationItem.rightBarButtonItem = completeBarButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
    
//    func updateCategory() {
//        let categoryTitle = inputCell?.contentsTextField.text ?? ""
//        viewModel.resumeCategory[]?.title
//        viewModel.updateCategory(category)
//    }
}

// MARK: - UITableViewDataSource

extension CategoryAddingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContentsInputCell = .init()
        cell.titleLabel.text = "제목"
        cell.contentsTextField.placeholder = "카테고리"
        return cell
    }
}
