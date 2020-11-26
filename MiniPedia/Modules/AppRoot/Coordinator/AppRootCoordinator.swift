//
//  AppRootCoordinator.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 16/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class AppRootCoordinator: ReactiveCoordinator<Void> {
    
    let rootController: AppRootBarViewController!
    
    init(rootViewController: AppRootBarViewController) {
        self.rootController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        
        let tabBarController = self.rootController
        tabBarController?.coordinator = self
        
        let homeCoordinator = HomeViewCoordinator(rootViewController: homeView.viewControllers[0])
        let cartCoordinator = CartCoordinator(rootViewController: cartView.viewControllers[0])
        let profileCoordinator = ProfileViewCoordinator(rootViewController: profileView.viewControllers[0])
        
        _ = [homeCoordinator, cartCoordinator, profileCoordinator].map {
            coordinate(to: $0)
        }
        
        tabBarController?.viewControllers = [
            homeView,
            cartView,
            profileView
        ]
        
        return Observable.never()
    }
    
    private var homeView: UINavigationController = {
        let controller = HomeView()
        let coordinator = HomeViewCoordinator(rootViewController: controller)
        coordinator.viewModel = HomeViewViewModel()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem =  UITabBarItem(title: "Home", image: UIImage(systemName: "dollarsign.circle.fill"), tag: 0)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }()
    
    private var cartView: UINavigationController = {
        let controller = CartView()
        let coordinator = CartCoordinator(rootViewController: controller)
        coordinator.viewModel = CartViewModel()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "bag.fill"), tag: 1)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }()
    
    private var profileView: UINavigationController = {
        let controller = ProfileView()
        let coordinator = ProfileViewCoordinator(rootViewController: controller)
        coordinator.viewModel = ProfileViewModel()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle.fill"), tag: 2)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }()
    
}
