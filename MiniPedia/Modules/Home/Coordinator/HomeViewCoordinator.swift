//
//  HomeViewCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 19/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class HomeViewCoordinator: ReactiveCoordinator<Void> {
    
    public let rootController: UIViewController
    public var viewModel = HomeViewViewModel()
    
    init(rootViewController: UIViewController) {
        self.rootController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        let viewController = rootController as! HomeView
        viewController.viewModel = viewModel
        return Observable.never()
    }
    
}
