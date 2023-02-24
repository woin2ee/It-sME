//
//  InsetTextField.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/24.
//

import UIKit

final class InsetTextField: UITextField {
    
    let inset: UIEdgeInsets
    
    init(frame: CGRect = .zero, inset: UIEdgeInsets = .init(top: 4, left: 10, bottom: 4, right: 10)) {
        self.inset = inset
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
}
