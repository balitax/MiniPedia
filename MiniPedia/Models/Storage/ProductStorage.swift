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
import RxCocoa
import RxDataSources


struct CartSection {
    var header: CartStorage
    var items: [ProductStorage]
}

extension CartSection: SectionModelType {
    typealias Item = ProductStorage
    init(original: CartSection, items: [ProductStorage]) {
        self = original
        self.items = items
    }
}

final class CartStorage: Object {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String?
    @objc dynamic var location: String?
    @objc dynamic var uri: String?
    @objc dynamic var merchantSelected: Bool = false
    var products = List<ProductStorage>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

final class ProductStorage: Object {
    
    @objc dynamic var id: Int = -1
    @objc dynamic var name: String?
    @objc dynamic var imageURI, imageURI700: String?
    @objc dynamic var price: String?
    @objc dynamic var rating: Int = 0
    @objc dynamic var countReview: Int = 0
    @objc dynamic var countSold: Int = 0
    @objc dynamic var stock: Int = 0
    @objc dynamic var quantity: Int = 0
    @objc dynamic var notes: String?
    @objc dynamic var productSelected: Bool = false
    
    var getStock: NSMutableAttributedString? {
        var attributedString = NSMutableAttributedString()
        if stock <= 10 {
            attributedString = NSMutableAttributedString()
                .normal("Stok ", fontSize: 12)
                .bold("tersisa < \(stock), ", fontSize: 12)
        } else {
            attributedString = NSMutableAttributedString()
                .normal("Stok ", fontSize: 12)
                .bold("tersisa > 10, ", fontSize: 12)
        }
        return attributedString
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
