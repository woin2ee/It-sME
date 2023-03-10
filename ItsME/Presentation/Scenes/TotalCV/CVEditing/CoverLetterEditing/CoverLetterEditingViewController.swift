//
//  CoverLetterEditingViewController.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/03.
//

import UIKit
import Then
import SnapKit

class CoverLetterEditingViewController: UIViewController, UITableViewDataSource {
    
    private let viewModel: CoverLetterEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var coverLetterEditTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.sectionHeaderHeight = 0
        let cellType = CoverLetterItemCell.self
        $0.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    private lazy var completeBarButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "완료", handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
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
}

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
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let coverLetter = viewModel
        
        let cell: CoverLetterItemCell = .init()
        
        cell.titleTexField.text = coverLetter.item.title
        cell.content.text = coverLetter.item.contents
        
        return cell
    }
}
