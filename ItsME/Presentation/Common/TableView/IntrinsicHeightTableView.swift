//
//  IntrinsicHeightTableView.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/19.
//

import UIKit

class IntrinsicHeightTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isScrollEnabled = false
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(
            width: self.contentSize.width + self.contentInset.left + self.contentInset.right,
            height: self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
