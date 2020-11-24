//
//  ProductListViewModel.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

struct ProductFilterBinding {
    var delegate: ProductFilterDelegate
    var filter: ProductFilterRequest?
}

class ProductListViewModel: BaseViewModel {
    
    let repository = ProductListRepository()
    var queryProduct = QueryProduct(query: "")
    let selectedProduct = PublishSubject<ProductListCellViewModel>()
    let cartButtonDidTap = PublishSubject<Void>()
    let backButtonDidTap = PublishSubject<Void>()
    let filterButtonDidTap = PublishSubject<ProductFilterBinding>()
    
    //MARK: - ViewModel DataSource
    private var products = BehaviorRelay<[ProductListCellViewModel]> (
        value: []
    )
    
    var productDriver: Driver<[ProductListCellViewModel]> {
        return products.asDriver()
    }
    
    var numberRowOfItems: Int? {
        self.products.value.count
    }
    
    func items(at indexPath: IndexPath) -> ProductListCellViewModel? {
        self.products.value.isEmpty ? nil : self.products.value[indexPath.row]
    }
    
    func selectedItem(at indexPath: IndexPath) {
        self.selectedProduct.onNext(self.products.value[indexPath.row])
    }
    
    func getProductList() {
        self.state.onNext(.loading)
        repository.getProductList(queryProduct)
            .observeOn(MainScheduler.instance)
            .compactMap({ product -> [ProductListCellViewModel] in
                
                var productViewModel = [ProductListCellViewModel]()
                
                for data in product.data {
                    let viewModel = ProductListCellViewModel(product: data)
                    productViewModel.append(viewModel)
                }
                
                return productViewModel
                
            })
            .subscribe { [weak self] viewModel in
                guard let self = self else { return }
                self.products.accept(viewModel)
                self.state.onNext(.finish)
            } onError: { error in
                self.state.onNext(.error)
            }.disposed(by: disposeBag)
    }
    
}
