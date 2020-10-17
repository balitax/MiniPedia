//
//  ProductDetailCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class ProductDetailCoordinator: ReactiveCoordinator<Void> {
    
    public let rootViewController: UIViewController
    public var viewModel: ProductListCellViewModel!
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
    
        let viewController          = ProductDetailView()
        let detailViewModel         = ProductDetailViewModel()
        
        detailViewModel.products.onNext(viewModel.product)
        viewController.viewModel    = detailViewModel
        
        rootViewController.navigationController?
            .pushViewController(viewController, animated: true)
        
        return Observable.never()
        
    }
    
}
