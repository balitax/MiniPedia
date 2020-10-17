//
//  ProductListCellViewModel.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

struct ProductListCellViewModel {
    
    var product: DataProducts?
    
    var productName: String
    var productPrice: String
    var productImage: String
    
    init(product: DataProducts) {
        self.productName = product.name ?? ""
        self.productPrice = product.price ?? ""
        self.productImage = product.imageURI ?? ""
        self.product = product
    }
    
}
