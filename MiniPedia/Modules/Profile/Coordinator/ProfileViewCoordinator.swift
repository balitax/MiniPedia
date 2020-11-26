//
//  ProfileViewCoordinator.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 20/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class ProfileViewCoordinator: ReactiveCoordinator<Void> {
    
    public let rootController: UIViewController
    public var viewModel = ProfileViewModel()
    
    init(rootViewController: UIViewController) {
        self.rootController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        let viewController = rootController as! ProfileView
        viewController.viewModel = viewModel
        
        return Observable.never()
    }
    
}
