//
//  AppRootCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 16/11/20.
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
        
        let homeViewController = homeView()
        let cartViewController = cartView()
        
        let homeCoordinator = HomeViewCoordinator(rootViewController: homeViewController.viewControllers[0])
        coordinate(to: homeCoordinator)
        
        let cartCoordinator = CartCoordinator(rootViewController: cartViewController.viewControllers[0])
        coordinate(to: cartCoordinator)
        
        tabBarController?.viewControllers = [
            homeViewController,
            cartViewController,
            profileView()
        ]
        
        return Observable.never()
    }
    
    func showScreen(_ screen: AppRootCoordinator.Screen) {}
    
    private func homeView() -> UINavigationController {
        let controller = HomeView()
        let coordinator = HomeViewCoordinator(rootViewController: controller)
        coordinator.viewModel = HomeViewViewModel()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem =  UITabBarItem(title: "Home", image: UIImage(systemName: "dollarsign.circle.fill"), tag: 0)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    private func cartView() -> UINavigationController {
        let controller = CartView()
        let coordinator = CartCoordinator(rootViewController: controller)
        coordinator.viewModel = CartViewModel()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "bag.fill"), tag: 1)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    private func profileView() -> UINavigationController {
        let controller = UIViewController()
        //        let coordinator = CartCoordinator(rootViewController: controller)
        //        coordinator.viewModel = CartViewModel()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle.fill"), tag: 2)
        return navigationController
    }
    
}


// MARK: - Screen
extension AppRootCoordinator {
    enum Screen {
        case home
        case cart
        case profile
    }
}
