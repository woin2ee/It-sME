//
//  CommonAlertViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/11/16.
//

import UIKit

@available(*, deprecated, message: "The UIAlertController class is intended to be used as-is and doesn’t support subclassing. The view hierarchy for this class is private and must not be modified.")
final class CommonAlertViewController: UIAlertController {
    
    /// 기본 세팅이 되어 있는 AlertViewController 를 만들어서 반환합니다.
    ///
    ///  - Parameters:
    ///     - title: Alert 상단에 볼드체로 표시되는 제목
    ///     - message: Alert 내부에 일반체로 표시되는 내용
    ///     - style: 어떤 기본 세팅을 사용할지 결정하는 매개변수
    ///     - okHandler: 취소가 아닌 확인 버튼을 눌러서 작업을 수행하고자 할때 실행할 블록
    convenience init(
        title: String,
        message: String,
        style: CommonAlertViewController.AlertViewStyle,
        okHandler: @escaping (() -> Void)
    ) {
        self.init(title: title, message: message, preferredStyle: .alert)
        switch style {
        case .confirm:
            makeConfirmAlert(okHandler: okHandler)
        case .Destruction:
            makeDestructionAlert(okHandler: okHandler)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func makeConfirmAlert(okHandler: @escaping (() -> Void)) {
        let cancelAction: UIAlertAction = .init(
            title: "아니오",
            style: .cancel
        )
        let okAction: UIAlertAction = .init(
            title: "예",
            style: .default,
            handler: { _ in
                okHandler()
            }
        )
        self.addAction(cancelAction)
        self.addAction(okAction)
    }
    
    private func makeDestructionAlert(okHandler: @escaping (() -> Void)) {
        let cancelAction: UIAlertAction = .init(
            title: "취소",
            style: .cancel
        )
        let deleteAction: UIAlertAction = .init(
            title: "삭제",
            style: .destructive,
            handler: { _ in
                okHandler()
            }
        )
        self.addAction(cancelAction)
        self.addAction(deleteAction)
    }
}

extension CommonAlertViewController {
    
    enum AlertViewStyle {
        case confirm
        case Destruction
    }
}
