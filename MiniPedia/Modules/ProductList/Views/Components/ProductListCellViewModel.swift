//
//  ProductListCellViewModel.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

struct ProductListCellViewModel {
    
    var product: DataProducts?
    var productName: String?
    var productPrice: String?
    var productImage: String?
    var productStarCount: String?
    
    init(product: DataProducts) {
        self.productName = product.name ?? ""
        self.productPrice = product.price ?? ""
        self.productImage = product.imageURI ?? ""
        self.productStarCount = product.getCountStar
        self.product = product
    }
    
    init(storage: ProductStorage) {
        self.productName = storage.name
        self.productPrice = storage.price
        self.productImage = storage.imageURI
        self.productStarCount = "\(storage.rating)"
        self.product = storage.toDataProduct()
    }
    
    init() {
     
    }
    
}
