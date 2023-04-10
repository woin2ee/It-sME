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
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - message: <#message description#>
    ///   - cancelAction: <#cancelAction description#>
    ///   - okAction: 확인 버튼에 해당하는 `UIAlertAction` 객체입니다. 이 파라미터로 넘긴 객체의 `handler` 는 실행되지 않습니다. 대신 `subscribe` 를 이용하여 `handler` 에 해당하는 작업을 실행하세요.
    ///   - animated: <#animated description#>
    /// - Returns: <#description#>
    func presentConfirmAlert(
        title: String,
        message: String? = nil,
        cancelAction: UIAlertAction = .init(title: "아니오", style: .cancel),
        okAction: UIAlertAction,
        animated: Bool = true
    ) -> ControlEvent<Void> {
        let source: Observable<Void> = .create { observer in
            let okActionProxy: UIAlertAction = .init(title: okAction.title, style: okAction.style) { _ in
                observer.onNext(())
                observer.onCompleted()
            }
            self.base.presentConfirmAlert(title: title, message: message, cancelAction: cancelAction, okAction: okActionProxy, animated: animated)
            
            return Disposables.create()
        }
        
        return ControlEvent<Void>.init(events: source)
    }
}
