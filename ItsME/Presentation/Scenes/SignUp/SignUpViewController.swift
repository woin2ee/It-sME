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
    
    private lazy var guideLabel: UILabel = .init().then {
        $0.text = "필수 정보를 입력해주세요!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
