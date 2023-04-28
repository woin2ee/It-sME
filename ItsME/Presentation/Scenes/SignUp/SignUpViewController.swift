//
//  SignUpViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/11.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class SignUpViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    private let viewModel: SignUpViewModel = .init()
    
    // MARK: Data Sources
    
    var inputTitleLabelTexts: [String] {
        ["주소", "전화번호", "생일"]
    }
    
    // MARK: Appearance
    
    let inputTitleLabelFont: UIFont = .preferredFont(forTextStyle: .headline, weight: .semibold)
    let inputTextFieldFont: UIFont = .preferredFont(forTextStyle: .body)
    let inputValidationLabelFont: UIFont = .preferredFont(forTextStyle: .subheadline)
    
    let inputValidationLabelColor: UIColor = .placeholderText
    
    // MARK: UI Objects
    
    private lazy var inputTitleLabels: [UILabel] = inputTitleLabelTexts.map { text in
        return UILabel().then {
            $0.text = text
            $0.font = inputTitleLabelFont
            $0.adjustsFontForContentSizeCategory = true
        }
    }
    private lazy var guideLabel: UILabel = .init().then {
        $0.text = "이력서에 들어갈 정보를 입력해주세요!"
        $0.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .hangulWordPriority
    }
    private lazy var birthdayDatePicker: DatePickerTextField = .init().then {
        $0.placeholder = "생년월일 입력(선택)"
        $0.borderStyle = .roundedRect
        $0.font = inputTextFieldFont
        $0.adjustsFontForContentSizeCategory = true
    }
    private lazy var addressTextField: UITextField = .init().then {
        $0.placeholder = "주소를 입력해주세요."
        $0.borderStyle = .roundedRect
        $0.font = inputTextFieldFont
        $0.adjustsFontForContentSizeCategory = true
    }
    private lazy var addressValidationLabel: UILabel = .init().then {
        $0.text = "선택 사항입니다."
        $0.textColor = inputValidationLabelColor
        $0.font = inputValidationLabelFont
        $0.adjustsFontForContentSizeCategory = true
    }
    private lazy var phoneNumberTextField: UITextField = .init().then {
        $0.placeholder = "전화번호를 입력해주세요."
        $0.borderStyle = .roundedRect
        $0.font = inputTextFieldFont
        $0.adjustsFontForContentSizeCategory = true
    }
    private lazy var phoneNumberValidationLabel: UILabel = .init().then {
        $0.text = "선택 사항입니다."
        $0.textColor = inputValidationLabelColor
        $0.font = inputValidationLabelFont
        $0.adjustsFontForContentSizeCategory = true
    }
    
    private lazy var startButton: UIButton = .init(configuration: .filled().with {
        let attributes: AttributeContainer = .init([
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        ])
        $0.attributedTitle = .init("시작하기", attributes: attributes)
        $0.baseBackgroundColor = .systemBlue
        $0.baseForegroundColor = .white
        $0.buttonSize = .large
    })
    
    // MARK: Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupConstraints()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Methods

extension SignUpViewController {
    
    private func setupConstraints() {
        // Declaration
        let containerScrollView: UIScrollView = .init().then {
            $0.backgroundColor = .clear
        }
        let contentView: UIView = .init().then {
            $0.backgroundColor = .clear
        }
        let inputStackView: UIStackView = .init().then {
            $0.axis = .vertical
            $0.spacing = 24.0
            $0.distribution = .equalSpacing
        }
        let makeInnerStackView: () -> UIStackView = {
            return UIStackView().then {
                $0.axis = .vertical
                $0.spacing = 4.0
            }
        }
        // Add Subviews
        self.view.addSubview(containerScrollView)
        containerScrollView.addSubview(contentView)
        contentView.addSubview(guideLabel)
        contentView.addSubview(inputStackView)
        
        inputStackView.addArrangedSubview(makeInnerStackView().then {
            $0.addArrangedSubview(inputTitleLabels[0])
            $0.addArrangedSubview(addressTextField)
            $0.addArrangedSubview(addressValidationLabel)
        })
        inputStackView.addArrangedSubview(makeInnerStackView().then {
            $0.addArrangedSubview(inputTitleLabels[1])
            $0.addArrangedSubview(phoneNumberTextField)
            $0.addArrangedSubview(phoneNumberValidationLabel)
        })
        inputStackView.addArrangedSubview(makeInnerStackView().then {
            $0.addArrangedSubview(inputTitleLabels[2])
            $0.addArrangedSubview(birthdayDatePicker)
        })
        
        contentView.addSubview(startButton)
        // Constraints
        containerScrollView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.directionalEdges.width.equalToSuperview()
        }
        guideLabel.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(34)
        }
        inputStackView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(30)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
        startButton.snp.makeConstraints { make in
            make.top.equalTo(inputStackView.snp.bottom).offset(50)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Binding ViewModel

extension SignUpViewController {
    
    private func bindViewModel() {
        let input = SignUpViewModel.Input(
            birthday: birthdayDatePicker.rx.text.orEmpty.asDriver().map({ stringDate in
                ItsMESimpleDateFormatter.date(from: stringDate) ?? Date.now
            }),
            address: addressTextField.rx.text.orEmpty.asDriver(),
            phoneNumber: phoneNumberTextField.rx.text.orEmpty.asDriver(),
            startTrigger: startButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        [
            output.signUpComplete
                .emit(with: self, onNext: { owner, _ in
                    let homeViewController: HomeViewController = .init()
                    owner.navigationController?.setViewControllers([homeViewController], animated: true)
                }),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
}

#if DEBUG

// MARK: - Canvas

import SwiftUI

@available(iOS 13.0, *)
struct SignUpViewControllerRepresenter: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let signUpViewController: SignUpViewController = .init()
        let navigationController: UINavigationController = .init(rootViewController: signUpViewController)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

@available(iOS 13.0, *)
struct SignUpViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        SignUpViewControllerRepresenter()
    }
}

#endif
