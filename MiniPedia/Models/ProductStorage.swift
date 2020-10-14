//
//  ProductStorage.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 14/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class ProductStorage: Object {
    
    @objc dynamic var id: Int = -1
    dynamic var name: String?
    dynamic var imageURI, imageURI700: String?
    dynamic var price: String?
    dynamic var merchantName: String?
    dynamic var rating: Int?
    dynamic var countReview, countSold, stock: Int?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

extension DataProducts: Persistable {
    
    public init(managedObject: ProductStorage) {
        id              = managedObject.id
        name            = managedObject.name
        imageURI        = managedObject.imageURI
        imageURI700     = managedObject.imageURI700
        price           = managedObject.price
        shop?.name      = managedObject.merchantName
        rating          = managedObject.rating
        countReview     = managedObject.countReview
        countSold       = managedObject.countSold
        stock           = managedObject.stock
    }
    
    public func managedObject() -> ProductStorage {
        let product             = ProductStorage()
        product.id              = id ?? 0
        product.name            = name
        product.imageURI        = imageURI
        product.imageURI700     = imageURI700
        product.price           = price
        product.merchantName    = shop?.name
        product.rating          = rating
        product.countReview     = countReview
        product.countSold       = countSold
        product.stock           = stock
        return product
    }
    
}
