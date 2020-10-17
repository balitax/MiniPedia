//
//  CartCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 15/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class CartCoordinator: ReactiveCoordinator<Void> {
    
    public let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        
        let viewController          = CartView()
        let viewModel               = CartViewModel()
        viewController.viewModel    = viewModel
        
        viewModel.backButtonDidTap
            .subscribe(onNext: { [unowned self] _ in
                rootViewController.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        rootViewController.navigationController?
            .pushViewController(viewController, animated: true)
        
        return Observable.never()
        
    }
    
}
