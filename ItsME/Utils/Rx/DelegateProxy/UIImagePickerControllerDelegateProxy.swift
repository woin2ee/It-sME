//
//  UIImagePickerControllerDelegateProxy.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/04.
//

import RxSwift
import RxCocoa

final class UIImagePickerControllerDelegateProxy:
    DelegateProxy<UIImagePickerController, (UIImagePickerControllerDelegate & UINavigationControllerDelegate)>,
    DelegateProxyType,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {

    static func registerKnownImplementations() {
        self.register { parent in
            return .init(parentObject: parent, delegateProxy: self)
        }
    }

    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
}
