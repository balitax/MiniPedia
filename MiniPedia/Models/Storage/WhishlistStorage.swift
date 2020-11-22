//
//  WhishlistStorage.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 20/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxCocoa
import RxDataSources

final class WhishlistStorage: Object {
    
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
    
    func copyFromCart(_ cart: ProductStorage) -> WhishlistStorage {
        let whishlist = WhishlistStorage()
        whishlist.id = cart.id
        whishlist.name = cart.name
        whishlist.imageURI = cart.imageURI
        whishlist.imageURI700 = cart.imageURI700
        whishlist.price = cart.price
        whishlist.rating = cart.rating
        whishlist.countReview = cart.countReview
        whishlist.countSold = cart.countSold
        whishlist.stock = cart.stock
        whishlist.quantity = cart.quantity
        whishlist.notes = cart.notes
        whishlist.productSelected = cart.productSelected
        return whishlist
    }
    
}
