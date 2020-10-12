//
//  UIViewController+Extension.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import PKHUD

extension UIViewController {
    func showProgress() {
        HUD.show(.progress)
    }
    
    func hideProgress() {
        HUD.hide()
    }
    
    func showMessage(_ message: String) {
        HUD.flash(.labeledError(title: nil, subtitle: message), delay: 1.5)
    }
}
