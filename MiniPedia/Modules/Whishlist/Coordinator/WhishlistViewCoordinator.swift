//
//  WhishlistViewCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 20/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class WhishlistViewCoordinator: ReactiveCoordinator<Void> {
    
    public let rootController: UIViewController
    public var viewModel = WhishlistViewModel()
    
    init(rootViewController: UIViewController) {
        self.rootController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        let viewController = WhishlistView()
        viewController.viewModel = viewModel
        
        viewController.hidesBottomBarWhenPushed = true
        rootController.navigationController?
            .pushViewController(viewController, animated: true)
        
        viewModel.backButtonDidTap
            .subscribe(onNext: { [unowned self] _ in
                self.rootController.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
}
