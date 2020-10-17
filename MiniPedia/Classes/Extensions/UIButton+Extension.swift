//
//  UIButton+Extension.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 16/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

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
    
    func isCheckboxTapped(_ status: Bool) {
        status ? self.setImage(UIImage.init(named: "icn_checkbox"), for: .normal) : self.setImage(UIImage.init(named: "icn_uncheckbox"), for: .normal)
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
