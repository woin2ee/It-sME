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
        
        editProfileButton.backgroundColor = .mainColor
        editProfileButton.layer.cornerRadius = 10
        profileImageView.contentMode = .scaleAspectFill
        
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
