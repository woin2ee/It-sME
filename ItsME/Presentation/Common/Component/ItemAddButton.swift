//
//  ItemAddButton.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/08.
//

import UIKit

final class ItemAddButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitle("+항목추가", for: .normal)
        self.setTitleColor(.blue, for: .normal)
    }
}
