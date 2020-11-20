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
    public var viewModel = ProductListViewModel()
    
    init(rootViewController: UIViewController, query: QueryProduct?) {
        self.rootViewController = rootViewController
        if let query = query {
            viewModel.queryProduct = query
        }
    }
    
    override func start() -> Observable<Void> {
        
        let viewController          = ProductListView()
        viewController.viewModel    = viewModel
        viewController.hidesBottomBarWhenPushed = true
        rootViewController.navigationController?
            .pushViewController(viewController, animated: true)
        
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
        
        viewModel.backButtonDidTap
            .subscribe(onNext: { [unowned self] _ in
                self.rootViewController.navigationController?.popViewController(animated: true)
            })
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
