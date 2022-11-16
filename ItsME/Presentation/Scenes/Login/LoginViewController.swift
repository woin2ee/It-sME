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
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        return UIImageView.init(image: UIImage.init(systemName: "wrench.and.screwdriver.fill"))
    }()
    private let appleLoginButton: ASAuthorizationAppleIDButton = .init(type: .signIn, style: .black)
    private let kakaoLoginButton: UIButton = {
        let button: UIButton = .init()
        let image: UIImage? = .init(named: "kakao_login_large")
        button.setImage(image, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        configureSubviews()
    }
}

// MARK: - Private methods

private extension LoginViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .white
    }
    
    func bindViewModel() {
        let input = LoginViewModel.Input.init(
            kakaoLoginRequest: kakaoLoginButton.rx.tap.asSignal(),
            appleLoginRequest: appleLoginButton.rx.controlEvent(.touchUpInside).asSignal()
        )
        let output = viewModel.transform(input: input)
        
        output.loggedIn
            .drive()
            .disposed(by: disposeBag)
    }
    
    func configureSubviews() {
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
    
    func layoutLoginButtons() {
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

private extension LoginViewController {
    
    struct LoginButtonSpec {
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
