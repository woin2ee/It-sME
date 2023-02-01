//
//  OtherItemEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/10.
//

import SnapKit
import Then
import UIKit

final class OtherItemEditingViewController: UIViewController {
    
    
    
    private lazy var completeButton: UIBarButtonItem = .init(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}

// MARK: - Private Functions

private extension OtherItemEditingViewController {
    
    func configureNavigationBar() {
        self.navigationItem.title = "새 항목"
        self.navigationItem.rightBarButtonItem = completeButton
    }
}
