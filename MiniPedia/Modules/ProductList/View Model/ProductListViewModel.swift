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

struct ProductSection {
    var header: String
    var items: [ProductListCellViewModel]
}

extension ProductSection: SectionModelType {
    typealias Item = ProductListCellViewModel
    init(original: ProductSection, items: [ProductListCellViewModel]) {
        self = original
        self.items = items
    }
}

class ProductListViewModel: BaseViewModel {
    
    let repository = ProductListRepository()
    var queryProduct = QueryProduct(query: "baju")
    let selectedProduct = PublishSubject<ProductListCellViewModel>()
    
    //MARK: - ViewModel DataSource
    var products = BehaviorSubject<[ProductSection]> (
        value: []
    )
    
    func getProductList() {
        self.state.onNext(.loading)
        repository.getProductList(queryProduct)
            .observeOn(MainScheduler.instance)
            .map({ product -> [ProductSection] in
                
                var sections: [ProductSection] = []
                product.data.forEach({ category in
                    let header = "\(category.id)"
                    
                    if let index = sections.firstIndex(where: { $0.header == header }) {
                        sections[index].items.append(contentsOf: product.data.compactMap { ProductListCellViewModel(product: $0) })
                    } else {
                        let section = ProductSection(header: header, items: product.data.compactMap { ProductListCellViewModel(product: $0) })
                        sections.append(section)
                    }
                    
                })
                return sections
            })
            .subscribe(onSuccess: { section in
                self.products.onNext(section)
                self.state.onNext(.finish)
            }, onError: { error in
                self.state.onNext(.error)
                self.products.onError(error)
            }).disposed(by: disposeBag)
    }
    
}






























