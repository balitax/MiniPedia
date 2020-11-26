//
//  UIButton+Extension.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 16/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIButton {
    
    @IBInspectable
    var isCheckBoxButton: Bool {
        get { return self.isSelected }
        set {
            if newValue {
                backgroundColor = .clear
                setImage(UIImage.init(named: "icn_uncheckbox"), for: .normal)
            } else {
                backgroundColor = .lightGray
                setImage(nil, for: .normal)
            }
        }
    }
    
    var isCheckBoxSelected: Bool {
        get { return self.isSelected }
        set {
            if newValue {
                self.setImage(UIImage.init(named: "icn_checkbox"), for: .normal)
            } else {
                self.setImage(UIImage.init(named: "icn_uncheckbox"), for: .normal)
            }
        }
    }
    
    func isCheckboxTapped(_ status: Bool) {
        status ?  self.setImage(UIImage.init(named: "icn_checkbox"), for: .normal) : self.setImage(UIImage.init(named: "icn_uncheckbox"), for: .normal)
    }
    
    func disabledButton() {
        self.isEnabled = false
        self.titleLabel?.textColor = .white
        self.backgroundColor = UIColor.gray
    }
    
    func enableBlueButton() {
        self.isEnabled = true
        self.titleLabel?.textColor = .white
        self.backgroundColor = UIColor(hexString: "#03ac0e")
    }
    
}

extension Reactive where Base: UIButton {
    
    var isCheckBoxSelected: Binder<Bool> {
        return Binder(self.base) { button, selected in
            if selected {
                button.setImage(UIImage.init(named: "icn_checkbox"), for: .normal)
            } else {
                button.setImage(UIImage.init(named: "icn_uncheckbox"), for: .normal)
            }
        }
    }
    
    
}
