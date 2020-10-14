//
//  AppCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class AppCoordinator: ReactiveCoordinator<Void> {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        
        let navigationController = UINavigationController(rootViewController: ProductListView())
        navigationController.navigationBar.isHidden = true
        
        let productListCoordinator = ProductListCoordinator(rootViewController: navigationController.viewControllers[0])
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return coordinate(to: productListCoordinator)
        
    }
    
}
