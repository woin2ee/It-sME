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
        let input = makeInput()
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .drive(userInfoBinding)
            .disposed(by: disposeBag)
        
        output.cvsInfo
            .drive(cvsInfoBinding)
            .disposed(by: disposeBag)
    }
    
    func makeInput() -> HomeViewModel.Input {
        let viewDidLoad = Observable.just(())
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let viewWillAppear = self.rx.sentMessage(#selector(self.viewWillAppear(_:)))
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        return .init(
            viewDidLoad: viewDidLoad,
            viewWillAppear: viewWillAppear
        )
    }
    
    var userInfoBinding: Binder<UserInfo> {
        return .init(self) { viewController, userInfo in
            // UserInfo 가 필요한 곳에 데이터 매핑
            print(userInfo.name)
        }
    }
    
    var cvsInfoBinding: Binder<[CVInfo]> {
        return .init(self) { viewController, cvsInfo in
            // CVsInfo 가 필요한 곳에 데이터 매핑
            print(cvsInfo.count)
        }
    }
    
    func configureSubviews() {
        self.view.addSubview(editProfileButton)
        self.view.addSubview(profileImageView)
        self.view.addSubview(vStackLayout)
        
        editProfileButton.backgroundColor = .mainColor
        editProfileButton.layer.cornerRadius = 10
        profileImageView.contentMode = .scaleAspectFill
        
        vStackLayout.addArrangedSubview(profileInfo)
        vStackLayout.backgroundColor = .mainColor
        vStackLayout.axis = .vertical
        vStackLayout.distribution = .fillEqually
        vStackLayout.spacing = 5
        
        
        
        editProfileButton.snp.makeConstraints { make in
            make.width.equalTo(70)
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
