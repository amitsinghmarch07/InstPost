//
//  UIButton+Extensions.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import UIKit

extension UIButton {
    func styleButton() {
        backgroundColor = isEnabled ? .customCoral : .customMutedCoral
//        setTitleColor(.white, for: .normal)
        tintColor = isEnabled ? .white : .lightGray
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
}


