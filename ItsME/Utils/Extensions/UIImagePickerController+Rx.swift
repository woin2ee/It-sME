//
//  UIImagePickerController+Rx.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/04.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIImagePickerController {
    
    var delegateProxy: DelegateProxy<UIImagePickerController, (UIImagePickerControllerDelegate & UINavigationControllerDelegate)> {
        return UIImagePickerControllerDelegateProxy.proxy(for: self.base)
    }
    
    var didFinishPickingImage: Observable<UIImage?> {
        let selector = #selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))
        return delegateProxy
            .methodInvoked(selector)
            .map { parameters in
                self.base.dismiss(animated: true)
                
                guard let info = parameters[1] as? [UIImagePickerController.InfoKey: Any] else {
                    assertionFailure("delegate 함수의 파라미터 타입이 일치하지 않습니다.")
                    return nil
                }
                if let image = info[.editedImage] as? UIImage {
                    return image
                }
                if let image = info[.originalImage] as? UIImage {
                    return image
                }
                return nil
            }
    }
}
