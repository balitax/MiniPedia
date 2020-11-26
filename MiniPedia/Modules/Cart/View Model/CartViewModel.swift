//
//  CartViewModel.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 15/10/20.
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
    
    var cart: Results<CartStorage> {
        let cart = Database.shared.get(type: CartStorage.self).sorted(byKeyPath: "id", ascending: false).filter("ANY products.isWhishlist == false ")
        return cart
    }
    
    let cartSelectObservable = BehaviorSubject<Bool>(value: false)
    let cartCountSelectObservable = BehaviorSubject<String>(value: "")
    let deleteAllCartObservable = PublishSubject<Void>()
    let buyNowObservable = PublishSubject<Void>()
    let viewDetailProduct = PublishSubject<ProductListCellViewModel>()
    
    private var selectAllCart = false
    
    var isAllCartSelected = BehaviorSubject<Bool>(value: false)
    
    func getCartData() {
        self.state.onNext(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Observable.collection(from: self.cart)
                .map { $0 }
                .subscribe { event in
                    
                    self.checkCartSelectable()
                    
                    self.state.onNext(.finish)
                }
                .disposed(by: self.disposeBag)
        }
        
    }
    
    func getDetailProduct(section: Int, rows: Int) {
        let product = self.cart[section].products[rows]
        let viewModel = ProductListCellViewModel(storage: product)
        self.viewDetailProduct.onNext(viewModel)
    }
    
    private func checkCartSelectable() {
        // cek, apa semua cart terpilih
        let allCartSelected = self.cart.filter {
            $0.merchantSelected == true
        }
        
        if allCartSelected.count == self.cart.count {
            self.selectAllCart = true
            self.isAllCartSelected.onNext(true)
        } else {
            self.selectAllCart = false
            self.isAllCartSelected.onNext(false)
        }
    }
    
    func countCartSelectable(){
        let counts = Array(cart.filter { $0.products.filter { $0.productSelected == true }.count > 0 }).count
        let selected = "Pilih semua barang (\(counts))"
        self.cartCountSelectObservable.onNext(selected)
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
            
            Observable.from([self.cart[section].products[rows]])
                .subscribe(Realm.rx.delete())
                .disposed(by: self.disposeBag)
        }
        else {
            Observable.from([self.cart[section]])
                .subscribe(Realm.rx.delete())
                .disposed(by: self.disposeBag)
        }
        
        self.checkCartSelectable()
    }
    
    func updateProductQuantity(section: Int, rows: Int, qty: Int) {
        try! Database.shared.database.write {
            self.cart[section].products[rows].quantity = qty
        }
        self.checkCartSelectable()
    }
    
    func addNoteProductToCartItem(section: Int, rows: Int, note: String) {
        try! Database.shared.database.write {
            self.cart[section].products[rows].notes = note
        }
        self.checkCartSelectable()
    }
    
    func didSelectProductItem(section: Int, rows: Int, isSelected: Bool) {
        try! Database.shared.database.write {
            /*
             * cek, apakah semua product terpilih,
             * jika YA, update select juga di merchants,
             * JIKA TIDAK, update product saja
             */
            
            self.cart[section].products[rows].productSelected = isSelected
            
            let allProductSelected = self.cart[section].products.filter {
                $0.productSelected == isSelected
            }
            
            if allProductSelected.count == self.cart[section].products.count {
                self.cart[section].merchantSelected = isSelected
            }
            
        }
        self.checkCartSelectable()
    }
    
    func didSelectAllProductMerchant(section: Int, selected: Bool) {
        try! Database.shared.database.write {
            self.cart[section].merchantSelected = selected
            self.cart[section].products.forEach { $0.productSelected = selected }
        }
        self.checkCartSelectable()
    }
    
    func didSelectAllCart() {
        self.selectAllCart.toggle()
        try! Database.shared.database.write {
            self.cart.forEach {
                $0.merchantSelected = selectAllCart
                $0.products.forEach {
                    $0.productSelected = selectAllCart
                }
            }
            self.cartSelectObservable.onNext(selectAllCart)
        }
        self.checkCartSelectable()
    }
    
    func didDeleteAllCart() {
        Observable.from([self.cart])
            .subscribe(Realm.rx.delete())
            .disposed(by: self.disposeBag)
    }
    
    // MARK: -- WHISHLIST
    func didMoveProductCartToWhishlist(section: Int, rows: Int) {
        
        try! Database.shared.database.write {
            self.cart[section].products[rows].isWhishlist = true
        }
        self.checkCartSelectable()
        
    }
    
}
