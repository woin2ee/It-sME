//
//  IntrinsicHeightTextView.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/21.
//

import UIKit

class IntrinsicHeightTextView: UITextView {
    
    override var intrinsicContentSize: CGSize {
        return .init(
            width: self.contentSize.width + self.contentInset.left + self.contentInset.right,
            height: self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        )
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
