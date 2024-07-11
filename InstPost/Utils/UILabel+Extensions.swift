//
//  UILabel+Extensions.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import UIKit

extension UILabel {
    func styleTitleLabel() {
        // Set the primary text color
        textColor = .customPrimaryTextColor
        // Optionally set other label properties like font, alignment, etc.
        font = UIFont.systemFont(ofSize: 25, weight: .bold)
        textAlignment = .center
    }
}
