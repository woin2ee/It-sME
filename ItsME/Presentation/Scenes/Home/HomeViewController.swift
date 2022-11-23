//
//  HomeViewController.swift
//  It'sME
//
//  Created by MacBook Air on 2022/11/07.
//

import UIKit
import RxSwift
import SnapKit

final class HomeViewController: UIViewController {
    
    
    
    private var disposeBag: DisposeBag = .init()
    
    private let viewModel: HomeViewModel = .init()
    
    private let profileImageView: UIImageView = {
        
        let profileImageView: UIImageView = .init(image: UIImage.init(named: "테스트이미지"))
        return profileImageView
    }()
    
    private let editProfileButton: UIButton = {
        let button: UIButton = .init()
        return button
    }()
    
    private var profileInfo: ProfileInfoComponent = .init(userInfoItem: .init(icon: .computer, contents: "asdfasdfasdfasdfklahsdfadhgladfljglakdghlijadfglkjahl"))
    
    private var vStackLayout = UIStackView()
    
    private let cvCard = CVCard()
    
    private var hStackLayout = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        configureSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.circular()
    }
}

// MARK: - Private functions

private extension HomeViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = .white
    }
    
    func bindViewModel() {
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let input = HomeViewModel.Input(viewWillAppear: viewWillAppear)
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .drive(onNext: { userInfo in
                // input 에 대한 output 으로 userInfo 를 받았을 때 수행할 작업 정의
                print(userInfo)
            })
            .disposed(by: disposeBag)
    }
    
    func configureSubviews() {
        self.view.addSubview(editProfileButton)
        self.view.addSubview(profileImageView)
        self.view.addSubview(vStackLayout)
        self.view.addSubview(hStackLayout)
        
        editProfileButton.backgroundColor = .mainColor
        editProfileButton.setTitle("프로필 수정", for: .normal)
        editProfileButton.layer.cornerRadius = 10
        profileImageView.contentMode = .scaleAspectFill
        
        vStackLayout.addArrangedSubview(profileInfo)
        vStackLayout.axis = .vertical
        vStackLayout.distribution = .fillEqually
        vStackLayout.spacing = 5
        
        cvCard.layer.cornerRadius = 10
        cvCard.backgroundColor = .mainColor
        
        hStackLayout.addArrangedSubview(cvCard)
        hStackLayout.axis = .horizontal
        hStackLayout.distribution = .fillEqually
        hStackLayout.spacing = 30
        
        editProfileButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.trailing.equalTo(-30)
            make.top.equalTo(50)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(150)
            make.centerX.equalTo(self.view)
            make.top.equalTo(editProfileButton.snp.bottom).offset(20)
        }
        
        vStackLayout.snp.makeConstraints { make in
            make.height.equalTo((vStackLayout.arrangedSubviews.count * 40))
            make.width.equalTo(300)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        hStackLayout.snp.makeConstraints{ make in
            make.top.equalTo(vStackLayout.snp.bottom).offset(70)
            make.height.equalTo(250)
            make.width.equalTo(200)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
}

//MARK: - for canvas
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = HomeViewController

    func makeUIViewController(context: Context) -> HomeViewController {
        return HomeViewController()
    }

    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
    }
}

@available(iOS 15.0.0, *)
struct HomeViewControllerPrivew: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
