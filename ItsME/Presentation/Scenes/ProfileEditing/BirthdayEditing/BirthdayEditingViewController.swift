//
//  BirthdayEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/01/10.
//

import SnapKit
import Then
import UIKit

final class BirthdayEditingViewController: UIViewController {
    
    private let viewModel: ProfileEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var datePickerView: UIDatePicker = .init().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .date
        $0.date = viewModel.currentBirthday
        $0.backgroundColor = .systemBackground
        let action: UIAction = .init { [weak self] _ in
            guard let self = self else { return }
            self.updateBirthday(by: self.datePickerView.date)
        }
        $0.addAction(action, for: .valueChanged)
    }
    
    private lazy var completeButton: UIBarButtonItem = .init().then {
        $0.primaryAction = .init(title: "완료", handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false)
            self.updateBirthday(by: self.datePickerView.date)
        })
    }
    
    // MARK: - Initializer
    
    init(viewModel: ProfileEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(white: 0.0, alpha: 0.3)
        configureSubviews()
        configureNavigationBar()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissDatePicker))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .curveEaseOut
        ) {
            self.datePickerView.snp.updateConstraints { make in
                make.height.equalTo(200)
            }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Private Functions

private extension BirthdayEditingViewController {
    
    func configureSubviews() {
        self.view.addSubview(datePickerView)
        datePickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    func configureNavigationBar() {
        let navigationItem: UINavigationItem = .init().then {
            $0.rightBarButtonItem = completeButton
        }
        let navigationBar = UINavigationBar.init().then {
            $0.backgroundColor = .systemBackground
            $0.items = [navigationItem]
        }
        
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(datePickerView.snp.top)
        }
    }
    
    func updateBirthday(by date: Date) {
        let dateFormatter: DateFormatter = .init().then {
            $0.dateFormat = "yyyy.MM.dd."
        }
        let birthday: String = dateFormatter.string(from: date)
        let newItem: UserInfoItem = .init(
            icon: .cake,
            contents: birthday
        )
        self.viewModel.updateBirthday(newItem)
    }
    
    @objc func dismissDatePicker() {
        self.dismiss(animated: false)
    }
}
