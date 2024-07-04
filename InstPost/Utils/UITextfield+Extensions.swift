//
//  UITextfield+Extension.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import UIKit

extension UITextField {
    func applyCustomStyle() {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.borderColor = UIColor.customDarkGray.cgColor
        layer.borderWidth = 0.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Optional: Add padding to the text field
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}

