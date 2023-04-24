//
//  UIImage+DefaultProfileImage.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/21.
//

import UIKit

extension UIImage {
    static let defaultProfileImage: UIImage = {
        guard let defaultProfileImage = UIImage(named: "default_profile_image") else {
            preconditionFailure("기본프로필이미지 Asset 이 없습니다.")
        }
        return defaultProfileImage
    }()
}
