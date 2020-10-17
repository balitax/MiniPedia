//
//  CartViewModel.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 15/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import RxRealm
import RealmSwift


class CartViewModel: BaseViewModel {
    
    deinit {
        print("##\(self)")
    }
    
//    private let realm = try! Realm()
    
    var cart: Results<CartStorage> {
        let cart = Database.shared.get(type: CartStorage.self).sorted(byKeyPath: "id", ascending: false)
        return cart
    }
    
    let backButtonDidTap = PublishSubject<Void>()
    
    
    
    func getCartData() {
        self.state.onNext(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Observable.collection(from: self.cart)
                .map { $0 }
                .subscribe { event in
                    self.state.onNext(.finish)
                }
                .disposed(by: self.disposeBag)
        }
        
    }
    
    func deleteCartByProductMerchant(section: Int, rows: Int) {
        /*
         * check, apakah produknya cuman 1 di merchant nya
         * jika 1, hapus data beserta merchants, jika lebih dari 1 hapus produknya aja
         */
        
        let productCheck = self.cart[section].products.count
        if productCheck > 1 {
            Observable.from([self.cart[section].products[rows]])
                .subscribe(Realm.rx.delete())
                .disposed(by: self.disposeBag)
        }
        else {
            Observable.from([self.cart[section]])
                .subscribe(Realm.rx.delete())
                .disposed(by: self.disposeBag)
        }
    }
    
    func updateProductQuantity(section: Int, rows: Int, qty: Int) {
        print("QTY ", qty)
        try! Database.shared.database.write {
            self.cart[section].products[rows].quantity = qty
        }
        
        print("KE UPDATE G ?", self.cart)
    }
    
}
