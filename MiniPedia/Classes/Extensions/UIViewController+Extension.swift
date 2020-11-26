//
//  UIViewController+Extension.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import SVProgressHUD
import Bauletto

enum AlertType {
    case success
    case warning
    case error
    case info
}

extension UIViewController {
    
    func showLoading() {
        SVProgressHUD.show()
    }
    
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    func showAlert(_ msg: String, type: AlertType = .success) {
        switch type {
        case .success:
            let bauletto = BaulettoSettings(icon: UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: msg, tintColor: UIColor.white, backgroundStyle: .dark, dismissMode: .automatic, hapticStyle: .medium, action: nil, fadeInDuration: 3.0)
            Bauletto.show(withSettings: bauletto)
        case .info:
            let bauletto = BaulettoSettings(icon: UIImage(systemName: "info.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: msg, tintColor: UIColor.blue, backgroundStyle: .dark, dismissMode: .automatic, hapticStyle: .medium, action: nil, fadeInDuration: 3.0)
            Bauletto.show(withSettings: bauletto)
        case .error:
            let bauletto = BaulettoSettings(icon: UIImage(systemName: "info.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: msg, tintColor: UIColor.red, backgroundStyle: .dark, dismissMode: .automatic, hapticStyle: .medium, action: nil, fadeInDuration: 3.0)
            Bauletto.show(withSettings: bauletto)
        case .warning:
            let bauletto = BaulettoSettings(icon: UIImage(systemName: "info.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), title: msg, tintColor: UIColor.yellow, backgroundStyle: .dark, dismissMode: .automatic, hapticStyle: .medium, action: nil, fadeInDuration: 3.0)
            Bauletto.show(withSettings: bauletto)
        }
    }
    
}
