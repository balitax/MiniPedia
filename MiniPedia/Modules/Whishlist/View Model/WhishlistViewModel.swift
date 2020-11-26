//
//  WhishlistViewModel.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 20/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift
import RxCocoa
import RxRealm
import RealmSwift

class WhishlistViewModel: BaseViewModel {
    
    deinit {
        print("##\(self)")
    }
    
    let backButtonDidTap = PublishSubject<Void>()
    let onSearchWhishlist = PublishSubject<Void>()
    let viewDetailProduct = PublishSubject<ProductListCellViewModel>()
    
    var whishlists: Results<CartStorage> {
        let whishlist = Database.shared.get(type: CartStorage.self).sorted(byKeyPath: "id", ascending: false).filter("ANY products.isWhishlist == true ")
        return whishlist
    }
    
    var whishlist: [ProductStorage] {
        var products = [ProductStorage]()
        for product in whishlists {
            products += product.products
        }
        return products
    }
    
    lazy var whishlistSearch = self.whishlist
    
    func getWhishlistData() {
        self.state.onNext(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Observable.collection(from: self.whishlists)
                .map { $0 }
                .subscribe { event in
                    self.state.onNext(.finish)
                }
                .disposed(by: self.disposeBag)
        }
        
    }
    
    func searchWhishlist(by query: String) {
        if query.isEmpty {
            self.resetSearch()
        } else {
            self.whishlistSearch = self.whishlist.filter ({ ($0.name ?? "").lowercased().contains(query.lowercased())})
            self.onSearchWhishlist.onNext(())
        }
    }
    
    func resetSearch() {
        self.whishlistSearch = whishlist
        self.onSearchWhishlist.onNext(())
    }
    
    func moveToCart(_ rows: Int) {
        try! Database.shared.database.write {
            self.whishlist[rows].isWhishlist = false
        }
    }
    
    func deleteWhishlist(rows: Int) {
        /*
         * check, apakah produknya cuman 1 di merchant nya
         * jika 1, hapus data beserta merchants, jika lebih dari 1 hapus produknya aja
         */
        
        let productCheck = self.whishlists.count
        if productCheck > 1 {
            Observable.from([self.whishlists[rows]])
                .subscribe(Realm.rx.delete())
                .disposed(by: self.disposeBag)
        }
        else {
            Observable.from([self.whishlists[rows]])
                .subscribe(Realm.rx.delete())
                .disposed(by: self.disposeBag)
        }
        
    }
    
    func getDetailProduct(rows: Int) {
        let product = self.whishlist[rows]
        let viewModel = ProductListCellViewModel(storage: product)
        self.viewDetailProduct.onNext(viewModel)
    }
    
}
