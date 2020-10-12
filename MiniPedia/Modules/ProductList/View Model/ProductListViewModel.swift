//
//  ProductListViewModel.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift
import RxCocoa

class ProductListViewModel: BaseViewModel {
    
    let repository = ProductListRepository()
    var queryProduct = QueryProduct(query: "baju")
    
    //MARK: - ViewModel DataSource
    var products = BehaviorSubject<[ProductListCellViewModel]> (
        value: []
    )
    
    func getProductList() {
        self.state.onNext(.loading)
        repository.getProductList(queryProduct)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { product in
                let products = product.data.compactMap { ProductListCellViewModel(product: $0) }
                self.products.onNext(products)
                self.state.onNext(.finish)
            }, onError: { error in
                self.state.onNext(.error)
            }).disposed(by: disposeBag)
    }
    
}






























