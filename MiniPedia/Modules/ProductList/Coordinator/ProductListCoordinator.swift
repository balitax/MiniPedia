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
                return coordinateToProductDetail(with: product)
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        
        return Observable.never()
        
    }
    
    private func coordinateToProductDetail(with productViewModel: ProductListCellViewModel) -> Observable<Void> {
        //        let holidayDetailCoordinator = HolidayDetailCoordinator(rootViewController: rootViewController)
        //        holidayDetailCoordinator.viewModel = holidayViewModel
        print("LALALA ", productViewModel)
        
        let productListCoordinator = ProductListCoordinator(rootViewController: self.rootViewController)
        
        return coordinate(to: productListCoordinator)
            .map { _ in () }
    }
    
}
