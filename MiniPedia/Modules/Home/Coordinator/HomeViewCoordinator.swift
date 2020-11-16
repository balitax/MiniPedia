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
        
        viewModel.getDetailProduct
            .flatMap( { [unowned self] product in
                return self.coordinateToProductDetail(with: product)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func coordinateToProductDetail(with productViewModel: ProductListCellViewModel) -> Observable<Void> {
        let productDetailCoordinator = ProductDetailCoordinator(rootViewController: rootController)
        productDetailCoordinator.viewModel = productViewModel
        return coordinate(to: productDetailCoordinator)
            .map { _ in () }
    }
    
}
