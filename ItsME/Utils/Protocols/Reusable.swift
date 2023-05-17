//
//  Reusable.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/14.
//

import ItsMEUtil
import UIKit

extension UITableViewCell: Reusable {
    public static var reuseIdentifier: String {
        .init(describing: self)
    }
}

extension UICollectionViewCell: Reusable {
    public static var reuseIdentifier: String {
        .init(describing: self)
    }
}
