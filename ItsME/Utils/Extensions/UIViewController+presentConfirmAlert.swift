//
//  UIViewController+presentConfirmAlert.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/31.
//

import RxSwift
import RxCocoa
import UIKit

extension UIViewController {

    /// <#Description#>
    /// - Parameters:
    ///   - title: 화면에 띄울 `UIAlertController` 의 `title`.
    ///   - message: 화면에 띄울 `UIAlertController` 의 `message`.
    ///   - cancelAction: 취소 버튼에 해당하는 `UIAlertAction` 객체입니다. 기본 `title` 은 "아니오" 로 설정되어있습니다.
    ///   - okAction: 확인 버튼에 해당하는 `UIAlertAction` 객체입니다.
    ///   - animated: `AlertController` 를 화면에 띄울 때 애니메이션을 적용할지에 대한 여부입니다.
    func presentConfirmAlert(
        title: String,
        message: String? = nil,
        cancelAction: UIAlertAction = .init(title: "취소", style: .cancel),
        okAction: UIAlertAction,
        animated: Bool = true
    ) {
        let alertController: UIAlertController = .init(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: animated)
    }
}

extension Reactive where Base: UIViewController {

    /// `UIAlertController` 를 띄우면서 확인 버튼을 선택했을 때만 이벤트를 방출하는 `Reactive wrapper` 를 반환합니다.
    /// - Parameters:
    ///   - title: 화면에 띄울 `UIAlertController` 의 `title`.
    ///   - message: 화면에 띄울 `UIAlertController` 의 `message`.
    ///   - cancelAction: 취소 버튼에 해당하는 `UIAlertAction` 객체입니다. 기본 `title` 은 "아니오" 로 설정되어있습니다.
    ///   - okAction: 확인 버튼에 해당하는 `UIAlertAction` 객체입니다. 이 파라미터로 넘긴 객체의 `handler` 는 실행되지 않습니다. 대신 `subscribe` 를 이용하여 `handler` 에 해당하는 작업을 실행하세요.
    ///   - animated: `AlertController` 를 화면에 띄울 때 애니메이션을 적용할지에 대한 여부입니다.
    /// - Returns: Reactive wrapper for positive action choices.
    func presentConfirmAlert(
        title: String,
        message: String? = nil,
        cancelAction: UIAlertAction = .init(title: "아니오", style: .cancel),
        okAction: UIAlertAction,
        animated: Bool = true
    ) -> ControlEvent<Void> {
        let source: Observable<Void> = .create { observer in
            MainScheduler.ensureRunningOnMainThread()

            let okActionProxy: UIAlertAction = .init(title: okAction.title, style: okAction.style) { _ in
                observer.onNext(())
                observer.onCompleted()
            }
            let cancelActionProxy: UIAlertAction = .init(title: cancelAction.title, style: cancelAction.style) { _ in
                observer.onCompleted()
            }
            self.base.presentConfirmAlert(title: title,
                                          message: message,
                                          cancelAction: cancelActionProxy,
                                          okAction: okActionProxy,
                                          animated: animated)
            return Disposables.create()
        }

        return ControlEvent<Void>.init(events: source)
    }
}
