//
//  AppRootBarViewController.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 16/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

class AppRootBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.layer.masksToBounds = true
        self.tabBar.barStyle = .black
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = Colors.greenColor
        
        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.tabBar.layer.shadowRadius = 6
        self.tabBar.layer.shadowOpacity = 1
        self.tabBar.layer.masksToBounds = false
    }
    
    var coordinator: AppRootCoordinator?
    
}
