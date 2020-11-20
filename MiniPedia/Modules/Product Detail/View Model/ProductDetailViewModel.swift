//
//  ProductDetailViewModel.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import Realm
import RealmSwift

class ProductDetailViewModel: BaseViewModel {
    
    deinit {
        print("##\(self)")
    }
    
    var cartState = PublishSubject<ShoppingState>()
    let cartButtonDidTap = PublishSubject<Void>()
    let backButtonDidTap = PublishSubject<Void>()
    let urlToko = PublishSubject<URL>()
    let shareThisProduct = PublishSubject<URL>()
    var products = BehaviorSubject<DataProducts?> (value: nil)
    
    func bindProduct() {
        DispatchQueue.main.async {
            self.state.onNext(.loading)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.state.onNext(.finish)
            }
        }
    }
    
    func saveCart() {
        products
            .compactMap { $0?.id }
            .asObservable()
            .subscribe(onNext: { [unowned self] idProduct in
                self.isProductAlreadyOnCart(id: idProduct) ? self.updateQuantityCart(idProduct) : self.addToCart()
            }).disposed(by: disposeBag)
        
    }
    
    func openTokopedia() {
        if let merchantURL = try! self.products.value()?.uri, let url = URL(string: merchantURL) {
            urlToko.onNext(url)
        }
    }
    
    func shareProduct() {
        if let merchantURL = try! self.products.value()?.uri, let url = URL(string: merchantURL) {
            shareThisProduct.onNext(url)
        }
    }
    
    private func addToCart() {
        self.cartState.onNext(.initial)
        products
            .observeOn(MainScheduler.instance)
            .compactMap { $0 }
            .filter { $0.shop != nil }
            .map({ [unowned self] product -> CartStorage in
                return self.saveCarts(product.shop!, product: product)
            })
        .flatMapLatest({ carts -> Single<CartStorage> in
            return Database.shared.rxsave(object: carts)
            }).subscribe(onNext: { [unowned self] cart in
                self.cartState.onNext(.done)
                }, onError: { [unowned self] error in
                    self.cartState.onNext(.error)
            }).disposed(by: disposeBag)
        
    }
    
    private func saveCarts(_ merchant: Shop, product: DataProducts) -> CartStorage {
        
        let getMerchant         = CartStorage()
        let products            = List<ProductStorage>()
        
        getMerchant.id          = merchant.id ?? 0
        getMerchant.name        = merchant.name
        getMerchant.location    = merchant.location
        getMerchant.uri         = merchant.uri
        
        let getProduct          = ProductStorage()
        getProduct.id           = product.id ?? 0
        getProduct.name         = product.name ?? ""
        getProduct.imageURI     = product.imageURI ?? ""
        getProduct.imageURI700  = product.name ?? ""
        getProduct.price        = product.price ?? ""
        getProduct.countReview  = product.countReview ?? 0
        getProduct.countSold    = product.countSold ?? 0
        getProduct.stock        = product.stock ?? 0
        getProduct.quantity     = 1
        
        products.append(getProduct)
        getMerchant.products    = products
        
        return getMerchant
        
    }
    
    private func isProductAlreadyOnCart(id: Int) -> Bool {
        let cart = Database.shared.get(type: CartStorage.self).sorted(byKeyPath: "id", ascending: false)
        return Array(cart.filter { $0.products.filter { $0.id == id }.count > 0 }).count != 0
    }
    
    private func updateQuantityCart(_ idProduct: Int) {
        let cart = Database.shared.get(type: ProductStorage.self).filter("id == \(idProduct)").first
        try! Database.shared.database.write {
            cart?.quantity += 1
        }
        self.cartState.onNext(.update)
    }
    
    
}
