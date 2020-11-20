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
        
        viewModel.showAllFashionProduct
            .flatMap( { [unowned self] query in
                return self.coordinateToProductList(with: query)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.showAllGadgetProduct
            .flatMap( { [unowned self] query in
                return self.coordinateToProductList(with: query)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.showAllPromoProduct
            .flatMap( { [unowned self] query in
                return self.coordinateToProductList(with: query)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.searchProductWithQuery
            .flatMap( { [unowned self] _ in
                return self.coordinateToProductList(with: nil)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.whishlistObservable
            .flatMap( { [unowned self] _ in
                return self.coordinateToWhishlist()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.cartObservable
            .subscribe(onNext: { [unowned self] _ in
                self.rootController.tabBarController?.selectedIndex = 1
            })
            .disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func coordinateToProductDetail(with productViewModel: ProductListCellViewModel) -> Observable<Void> {
        let productDetailCoordinator = ProductDetailCoordinator(rootViewController: rootController)
        productDetailCoordinator.viewModel = productViewModel
        return coordinate(to: productDetailCoordinator)
            .map { _ in () }
    }
    
    private func coordinateToProductList(with query: QueryProduct?) -> Observable<Void> {
        let productListCoordinator = ProductListCoordinator(rootViewController: rootController, query: query)
        return coordinate(to: productListCoordinator)
            .map { _ in () }
    }
    
    private func coordinateToWhishlist() -> Observable<Void> {
        let whishlistCoordinator = WhishlistViewCoordinator(rootViewController: rootController)
        return coordinate(to: whishlistCoordinator)
            .map { _ in () }
    }
    
}
