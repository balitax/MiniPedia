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
        
        viewModel.selectedProduct
            .flatMap( { [unowned self] (product) in
                return self.coordinateToProductDetail(with: product)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.cartButtonDidTap
            .flatMapLatest({ [unowned self] _ in
                return self.coordinateToCart()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        
        return Observable.never()
        
    }
    
    private func coordinateToProductDetail(with productViewModel: ProductListCellViewModel) -> Observable<Void> {
        let productDetailCoordinator = ProductDetailCoordinator(rootViewController: rootViewController)
        productDetailCoordinator.viewModel = productViewModel
        return coordinate(to: productDetailCoordinator)
            .map { _ in () }
    }
    
    private func coordinateToCart() -> Observable<Void> {
        let cartCoordinator = CartCoordinator(rootViewController: rootViewController)
        return coordinate(to: cartCoordinator)
            .map { _ in () }
    }
    
}
