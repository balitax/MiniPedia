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


class ProductDetailViewModel: BaseViewModel {
    
    deinit {
        print("##\(self)")
    }
    
    var product: DataProducts?
    var products = BehaviorSubject<DataProducts?> (
        value: nil
    )
    
    func bindProduct() {
        DispatchQueue.main.async {
            self.state.onNext(.loading)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.products.onNext(self.product)
                self.state.onNext(.finish)
            }
        }
    }
    
    
}
