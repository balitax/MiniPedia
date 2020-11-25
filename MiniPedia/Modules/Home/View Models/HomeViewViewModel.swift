//
//  HomeViewViewModel.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 19/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewViewModel: BaseViewModel {
    
    private let repository = ProductListRepository()
    var fashionQueryProduct = QueryProduct(query: "fashion wanita")
    var gadgetQueryProduct = QueryProduct(query: "gadget")
    var promoQueryProduct = QueryProduct(query: "diskon")
    private var infoAccountFakeRequest: Bool?
    
    var whishlistObservable = PublishSubject<Void>()
    var cartObservable = PublishSubject<Void>()
    
    var getDetailProduct = PublishSubject<ProductListCellViewModel>()
    var showAllFashionProduct = PublishSubject<QueryProduct>()
    var showAllGadgetProduct = PublishSubject<QueryProduct>()
    var showAllPromoProduct = PublishSubject<QueryProduct>()
    var searchProductWithQuery = PublishSubject<Void>()
    
    
    // MARK: -- Number Of Rows
    var numberOfFashionRows = BehaviorRelay<Int>(value: 0)
    var numberOfGadgetRows = BehaviorRelay<Int>(value: 0)
    var numberOfPromoRows = BehaviorRelay<Int>(value: 0)
    
    
    //MARK: - ViewModel DataSource
    private var popularFashion = BehaviorRelay<[DataProducts]> (
        value: []
    )
    
    private var gadgetProduct = BehaviorRelay<[DataProducts]> (
        value: []
    )
    
    private var promoProduct = BehaviorRelay<[DataProducts]> (
        value: []
    )
    
    private var fakeBanner = BehaviorRelay<[String]> (
        value: []
    )
    
    func getPopularFashionProductList() {
        self.state.onNext(.loading)
        repository.getProductList(fashionQueryProduct)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { products in
                self.popularFashion.accept(products.data)
                self.numberOfFashionRows.accept(products.data.count)
                self.state.onNext(.finish)
            }, onError: { error in
                self.state.onNext(.error)
            }).disposed(by: disposeBag)
    }
    
    func getGadgetProductList() {
        self.state.onNext(.loading)
        repository.getProductList(gadgetQueryProduct)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { products in
                self.gadgetProduct.accept(products.data)
                self.numberOfGadgetRows.accept(products.data.count)
                self.state.onNext(.finish)
            }, onError: { error in
                self.state.onNext(.error)
            }).disposed(by: disposeBag)
    }
    
    func getPromoProductList() {
        self.state.onNext(.loading)
        repository.getProductList(promoQueryProduct)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { products in
                self.promoProduct.accept(products.data)
                self.numberOfPromoRows.accept(products.data.count)
                self.state.onNext(.finish)
            }, onError: { error in
                self.state.onNext(.error)
            }).disposed(by: disposeBag)
    }
    
    func getAccountInfo() {
        self.state.onNext(.loading)
        Delay.wait(delay: 6) {
            self.infoAccountFakeRequest = true
            self.state.onNext(.finish)
        }
    }
    
    func fetchFakeBanner() {
        self.state.onNext(.loading)
        Delay.wait(delay: 4) {
            self.fakeBanner.accept(Constants.tokopediaBanners)
            self.state.onNext(.finish)
        }
    }
    
}


// MARK: -- Product Info
extension HomeViewViewModel {
    
    func fashionProduct(at indexPath: IndexPath) -> DataProducts? {
        self.popularFashion.value.isEmpty ? nil : self.popularFashion.value[indexPath.row]
    }
    
    func gadgetProduct(at indexPath: IndexPath) -> DataProducts? {
        self.gadgetProduct.value.isEmpty ? nil : self.gadgetProduct.value[indexPath.row]
    }
    
    func discountProduct(at indexPath: IndexPath) -> DataProducts? {
        self.promoProduct.value.isEmpty ? nil : self.promoProduct.value[indexPath.row]
    }
    
    func getDetailProduct(indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if !self.popularFashion.value.isEmpty {
                self.getDetailProduct.onNext(
                    ProductListCellViewModel(product: self.popularFashion.value[indexPath.row]))
            }
        case 2:
            if !self.gadgetProduct.value.isEmpty {
                self.getDetailProduct.onNext(
                    ProductListCellViewModel(product: self.gadgetProduct.value[indexPath.row]))
            }
        case 3:
            if !self.promoProduct.value.isEmpty {
                self.getDetailProduct.onNext(
                    ProductListCellViewModel(product: self.promoProduct.value[indexPath.row]))
            }
        default:
            break
        }
    }
}


// MARK: - Account Info
extension HomeViewViewModel {
    
    func bindInfoCell() -> Bool? {
        return self.infoAccountFakeRequest
    }
    
    func bindFakeBanner() -> [String]? {
        return self.fakeBanner.value
    }
    
}
