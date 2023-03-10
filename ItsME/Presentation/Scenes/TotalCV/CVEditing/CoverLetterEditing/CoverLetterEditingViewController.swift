//
//  CoverLetterEditingViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/03.
//

import UIKit
import Then
import SnapKit

final class CoverLetterEditingViewController: UIViewController {
    
    private let viewModel: CoverLetterEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var coverLetterEditTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.sectionHeaderHeight = 0
    }
    
    private lazy var completeBarButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "완료", handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
    }
    
    var coverLetterItemCell: CoverLetterItemCell? {
        coverLetterEditTableView.visibleCells[ifExists: 0] as? CoverLetterItemCell
    }
    
    // MARK: - Initializer
    init(viewModel: CoverLetterEditingViewModel) {
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
        coverLetterItemCell?.titleTextField.becomeFirstResponder()
    }
}

//MARK: - Private Function
extension CoverLetterEditingViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .systemGroupedBackground
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "자기소개서 편집"
        self.navigationItem.rightBarButtonItem = completeBarButton
        self.navigationItem.rightBarButtonItem?.style = .done
    }
    
    func configureSubviews() {
        
        self.view.addSubview(coverLetterEditTableView)
        coverLetterEditTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
}

//MARK: - TableView
extension CoverLetterEditingViewController :UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CoverLetterItemCell = .init()
        
        cell.titleTextField.text = viewModel.coverLetterItem.title
        cell.content.text = viewModel.coverLetterItem.contents
        
        return cell
    }
}
