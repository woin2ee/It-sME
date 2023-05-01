//
//  Reusable.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/14.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: Reusable {
    static var reuseIdentifier: String {
        .init(describing: self)
    }
}

extension UICollectionViewCell: Reusable {
    static var reuseIdentifier: String {
        .init(describing: self)
    }
}
