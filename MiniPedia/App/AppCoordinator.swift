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
        
        // HOME
        let tabBarController = AppRootBarViewController()
        let tabbarCoordinator = AppRootCoordinator(rootViewController: tabBarController)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        return coordinate(to: tabbarCoordinator).take(1)
        
    }
    
}
