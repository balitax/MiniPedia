//
//  ProductFilterViewModel.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 24/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift
import RxCocoa

struct MerchantTypeBinding {
    var delegate: MerchantTypeViewDelegate
    var selected: [ShopTypeModel]
}


class ProductFilterViewModel: BaseViewModel {
    
    var request = ProductFilterRequest.shared
    let merchantTypeDidTap = PublishSubject<MerchantTypeBinding>()
}
