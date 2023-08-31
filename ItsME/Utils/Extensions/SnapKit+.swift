//
//  SnapKit+.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/02.
//

import SnapKit

extension ConstraintMakerExtendable {

    @discardableResult
    @inlinable
    func equalToZero() -> ConstraintMakerEditable {
        return equalTo(0)
    }
}
