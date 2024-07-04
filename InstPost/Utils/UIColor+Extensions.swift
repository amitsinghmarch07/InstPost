//
//  UIColor+Extensions.swift
//  InstPost
//
//  Created by Amit singh on 03/07/24.
//

import UIKit

extension UIColor {
    static let customLightBlue = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0).lighter(by: 25) // Lighter light blue background
    // Light blue background
    static let customDarkBlue = UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1.0)   // Dark blue for text
    static let customAccentBlue = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1.0) // Lighter accent blue
    static let customCoral = UIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 1.0)     // Coral color for button
    static let customLightGray = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0) // Light gray for text field border
    static let customDarkGray = UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0)    // Dark gray for button border (if needed)
    static let customDisabledGray = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0) // Disabled state color
    static let customMutedCoral = UIColor(red: 255/255, green: 179/255, blue: 151/255, alpha: 1.0) // Muted coral color for disabled state
    static let customPrimaryTextColor = UIColor(red: 0/255, green: 51/255, blue: 102/255, alpha: 1.0) // Dark Blue for primary text
    static let customSecondaryTextColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1.0) // Medium Gray for secondary text
    
    func lighter(by percentage: CGFloat = 25.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }
    
    func adjust(by percentage: CGFloat = 25.0) -> UIColor? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
