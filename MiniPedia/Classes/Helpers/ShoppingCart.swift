//
//  ShoppingCart.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 14/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

enum RealmError: Error {
    case alreadySave
}

enum ShoppingState {
    case initial
    case error
    case done
    case update
}

class ShoppingCart {
    
    static let shared = ShoppingCart()
    
    var products: Results<CartStorage> {
        return Database.shared.get(type: CartStorage.self).sorted(byKeyPath: "id", ascending: false)
    }
    
    var whishlists: Results<WhishlistStorage> {
        return Database.shared.get(type: WhishlistStorage.self).sorted(byKeyPath: "id", ascending: false)
    }
    
}
