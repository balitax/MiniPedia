//
//  ProductListCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class ProductListCoordinator: ReactiveCoordinator<Void> {
    
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        
        let viewController          = rootViewController as! ProductListView
        let viewModel               = ProductListViewModel()
        viewController.viewModel    = viewModel
        
        return Observable.never()
        
    }
    
}
