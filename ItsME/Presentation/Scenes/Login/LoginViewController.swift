//
//  LoginViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/15.
//

import UIKit
import RxSwift
import SnapKit
import AuthenticationServices

final class LoginViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    
    private let viewModel: LoginViewModel = .init()
    
    // MARK: UI Components
    
    private let logoImageView: UIImageView = {
        return UIImageView.init(image: UIImage.init(named: "its_me_logo"))
    }()
    private let appleLoginButton: ASAuthorizationAppleIDButton = .init(type: .signIn, style: .black)
    private let kakaoLoginButton: UIButton = {
        let button: UIButton = .init()
        let image: UIImage? = .init(named: "kakao_login_large")
        button.setImage(image, for: .normal)
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        configureSubviews()
    }
}

// MARK: - Binding ViewModel

extension LoginViewController {
    
    private func bindViewModel() {
        let input = LoginViewModel.Input.init(
            kakaoLoginRequest: kakaoLoginButton.rx.tap.asSignal(),
            appleLoginRequest: appleLoginButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        output.loggedInAndNeedsSignUp
            .emit(with: self) { owner, needsSignUp in
                switch needsSignUp {
                case .needed(name: let name, email: let email):
                    let viewModel: SignUpViewModel = .init(userNameForSignUp: name, userEmailForSignUp: email)
                    let signUpViewController: SignUpViewController = .init(viewModel: viewModel)
                    owner.navigationController?.setViewControllers([signUpViewController], animated: false)
                case .notNeeded:
                    let homeViewController: HomeViewController = .init()
                    owner.navigationController?.setViewControllers([homeViewController], animated: false)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods

extension LoginViewController {
    
    private func configureAppearance() {
        self.view.backgroundColor = .white
    }
    
    private func configureSubviews() {
        self.view.addSubview(logoImageView)
        self.view.addSubview(appleLoginButton)
        self.view.addSubview(kakaoLoginButton)
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).multipliedBy(0.7)
            make.width.height.equalTo(200)
        }
        
        layoutLoginButtons()
    }
    
    private func layoutLoginButtons() {
        let screenWidth = self.view.safeAreaLayoutGuide.layoutFrame.size.width
        let widthInset: CGFloat = 60
        let buttonSpec: LoginButtonSpec = .init(width: screenWidth - widthInset)
        
        appleLoginButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSpec.size)
            make.centerX.equalTo(self.view)
            make.top.equalTo(logoImageView.snp.bottom).offset(60)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSpec.size)
            make.centerX.equalTo(self.view)
            make.top.equalTo(appleLoginButton.snp.bottom).offset(20)
        }
    }
}

// MARK: - LoginButtonSpec

extension LoginViewController {
    
    private struct LoginButtonSpec {
        let ratio: CGFloat = 90/600
        let width: CGFloat
        var height: CGFloat {
            ratio * width
        }
        var size: CGSize {
            .init(width: width, height: height)
        }
        
        init(width: CGFloat = 335) {
            self.width = width
        }
    }
}
