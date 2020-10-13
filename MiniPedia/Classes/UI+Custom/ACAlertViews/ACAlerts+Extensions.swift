//
//  ACAlerts+Extensions.swift
//  ACAlerts
//
//  Created by Agus Cahyono on 14/09/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    func addWindowSubview(_ view: UIView) {
        if self.superview == nil {
            let frontToBackWindows = UIApplication.shared.windows.reversed()
            for window in frontToBackWindows {
                if window.windowLevel == UIWindow.Level.normal
                    && !window.isHidden
                    && window.frame != CGRect.zero {
                    window.addSubview(view)
                    return
                }
            }
        }
    }
    
    func isHasNavigationBar() -> Bool {
        let window = UIApplication.shared.windows.first
        if ((window?.rootViewController?.navigationController?.navigationBar.isHidden) != nil) {
            return false
        } else {
            return true
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor, borderColor: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 0.6
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
}

public extension UIColor {
    
    static var lightRed: UIColor {
        return UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 0.9)
    }
    
    static var greenIce: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 1.0, blue: 249.0 / 255.0, alpha: 1.0)
    }
    
    static var lightGreen: UIColor {
        return UIColor(red: 71.0 / 255.0, green: 215.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
    
    static var lightPink: UIColor {
        return UIColor(red: 1.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    static var redCoral: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 84.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    }
    
    static var iceBlue: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 249.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    static var darkBlue: UIColor {
        return UIColor(red: 47.0 / 255.0, green: 134.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }
    
    static var goldenYellow: UIColor {
        return UIColor(red: 1.0, green: 192.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0)
    }
    
    static var grayShadow: UIColor {
        return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    }
    
}
