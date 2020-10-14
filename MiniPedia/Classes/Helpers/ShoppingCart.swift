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
}

class ShoppingCart {
    
    static let shared = ShoppingCart()
    
    private let realm = try! Realm()
    private let disposeBag = DisposeBag()
    
    public lazy var carts: BehaviorSubject<[ProductStorage]> = {
        let result = realm.objects(ProductStorage.self)
        return .init(value: Array(result))
    }()
    
    var products: Results<ProductStorage> {
        let cart = realm.objects(ProductStorage.self).sorted(byKeyPath: "id", ascending: false)
        return cart
    }
    
    var shoppingState = PublishSubject<ShoppingState>()
    
    private init() {}
    
    func addToCart(_ product: DataProducts?) {
        if let product = product {
            
            shoppingState.onNext(.initial)
            let existingProduct = realm.object(ofType: ProductStorage.self, forPrimaryKey: product.id)
            
            if existingProduct != nil {
                // data already saved
                shoppingState.onNext(.error)
            } else {
                // add new data
                let container = try! RealmContainer()
                try! container.write { transaction in
                    transaction.add(product, update: .all)
                }
                shoppingState.onNext(.done)
            }
            
        }
    }
    
}
