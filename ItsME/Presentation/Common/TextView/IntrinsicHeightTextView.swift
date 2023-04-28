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
            width: self.bounds.width,
            height: self.contentSize.height + self.adjustedContentInset.top + self.adjustedContentInset.bottom
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
