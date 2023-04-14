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
        ["이름", "생일", "주소", "전화번호", "이메일"]
    }
    
    // MARK: Appearance
    
    let inputTitleLabelFont: UIFont = .preferredFont(forTextStyle: .headline, weight: .semibold)
    let inputTextFieldFont: UIFont = .preferredFont(forTextStyle: .body)
    let inputValidationLabelFont: UIFont = .preferredFont(forTextStyle: .caption1)
    
    let inputValidationLabelColor: UIColor = .systemRed
    
    // MARK: UI Objects
    
    private lazy var inputTitleLabels: [UILabel] = inputTitleLabelTexts.map { text in
        return UILabel().then {
            $0.text = text
            $0.font = inputTitleLabelFont
            $0.adjustsFontForContentSizeCategory = true
        }
    }
    private lazy var guideLabel: UILabel = .init().then {
        $0.text = "이력서에 들어갈 필수 정보를 입력해주세요!"
        $0.font = .preferredFont(forTextStyle: .title1, weight: .bold)
        $0.adjustsFontForContentSizeCategory = true
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .hangulWordPriority
    }
    private lazy var nameTextField: UITextField = .init().then {
        $0.placeholder = "이름을 입력해주세요."
        $0.borderStyle = .roundedRect
        $0.font = inputTextFieldFont
        $0.adjustsFontForContentSizeCategory = true
    }
    private lazy var nameValidationLabel: UILabel = .init().then {
        $0.text = "필수 항목입니다."
        $0.textColor = inputValidationLabelColor
        $0.isHidden = true
        $0.font = inputValidationLabelFont
        $0.adjustsFontForContentSizeCategory = true
    }
    private lazy var birthdayDatePicker: UIDatePicker = .init().then {
        $0.contentHorizontalAlignment = .leading
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
    }
    private lazy var addressTextField: UITextField = .init().then {
        $0.placeholder = "주소를 입력해주세요."
        $0.borderStyle = .roundedRect
        $0.font = inputTextFieldFont
        $0.adjustsFontForContentSizeCategory = true
    }
    private lazy var addressValidationLabel: UILabel = .init().then {
        $0.text = "필수 항목입니다."
        $0.textColor = inputValidationLabelColor
        $0.isHidden = true
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
        $0.text = "필수 항목입니다."
        $0.textColor = inputValidationLabelColor
        $0.isHidden = true
        $0.font = inputValidationLabelFont
        $0.adjustsFontForContentSizeCategory = true
    }
    private lazy var emailTextField: UITextField = .init().then {
        $0.placeholder = "이메일을 입력해주세요."
        $0.borderStyle = .roundedRect
        $0.font = inputTextFieldFont
        $0.adjustsFontForContentSizeCategory = true
    }
    private lazy var emailValidationLabel: UILabel = .init().then {
        $0.text = "필수 항목입니다."
        $0.textColor = inputValidationLabelColor
        $0.isHidden = true
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
            $0.addArrangedSubview(nameTextField)
            $0.addArrangedSubview(nameValidationLabel)
        })
        inputStackView.addArrangedSubview(makeInnerStackView().then {
            $0.addArrangedSubview(inputTitleLabels[1])
            $0.addArrangedSubview(birthdayDatePicker)
        })
        inputStackView.addArrangedSubview(makeInnerStackView().then {
            $0.addArrangedSubview(inputTitleLabels[2])
            $0.addArrangedSubview(addressTextField)
            $0.addArrangedSubview(addressValidationLabel)
        })
        inputStackView.addArrangedSubview(makeInnerStackView().then {
            $0.addArrangedSubview(inputTitleLabels[3])
            $0.addArrangedSubview(phoneNumberTextField)
            $0.addArrangedSubview(phoneNumberValidationLabel)
        })
        inputStackView.addArrangedSubview(makeInnerStackView().then {
            $0.addArrangedSubview(inputTitleLabels[4])
            $0.addArrangedSubview(emailTextField)
            $0.addArrangedSubview(emailValidationLabel)
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
            make.top.equalToSuperview().inset(20)
        }
        inputStackView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(20)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
        startButton.snp.makeConstraints { make in
            make.top.equalTo(inputStackView.snp.bottom).offset(40)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Binding ViewModel

extension SignUpViewController {
    
    private func bindViewModel() {
        let input = SignUpViewModel.Input(
            name: nameTextField.rx.text.orEmpty.asDriver(),
            birthday: birthdayDatePicker.rx.date.asDriver(),
            address: addressTextField.rx.text.orEmpty.asDriver(),
            phoneNumber: phoneNumberTextField.rx.text.orEmpty.asDriver(),
            email: emailTextField.rx.text.orEmpty.asDriver(),
            startTrigger: startButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        output.signUpComplete
            .emit(with: self, onNext: { owner, _ in
                let homeViewController: HomeViewController = .init()
                owner.navigationController?.setViewControllers([homeViewController], animated: true)
            })
            .disposed(by: disposeBag)
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
