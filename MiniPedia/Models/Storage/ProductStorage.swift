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

final class ProductStorage: Object, NSCopying {
    
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
    
    let objects = LinkingObjects(fromType: CartStorage.self, property: "products")
    
    // split product for whishlist
    @objc dynamic var shopLocation: String?
    @objc dynamic var isWhishlist: Bool = false
    
    func getShopLocation(id: Int) -> String {
        if let location = Database.shared.get(type: CartStorage.self).sorted(byKeyPath: "id", ascending: false).filter("ANY products.id == \(id) ").first {
            return location.location ?? ""
        } else {
            return ""
        }
    }
    
    var getStock: NSMutableAttributedString? {
        var attributedString = NSMutableAttributedString()
        if stock <= 10 {
            attributedString = NSMutableAttributedString()
                .normal("Stok ", fontSize: 12)
                .bold("tersisa < \(stock) ", fontSize: 12)
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
    
    func copy(with zone: NSZone? = nil) -> Any {
        return ProductStorage(value: self)
    }
    
    func toDataProduct() -> DataProducts {
        var product         = DataProducts()
        product.id          = self.id
        product.name        = self.name
        product.imageURI    = self.imageURI
        product.imageURI700 = self.imageURI700
        product.price       = self.price
        product.rating      = self.rating
        product.countReview = self.countReview
        product.countSold   = self.countSold
        product.stock       = self.stock
        return product
    }
    
}
