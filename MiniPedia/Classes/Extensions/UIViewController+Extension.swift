//
//  UIViewController+Extension.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    
    func showLoading() {
        SVProgressHUD.show()
    }
    
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
}
