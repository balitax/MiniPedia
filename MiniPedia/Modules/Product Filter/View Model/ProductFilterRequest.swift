//
//  ProductFilterRequest.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 08/09/20.
//

import Foundation

struct ProductFilterRequest {
    
    static var shared = ProductFilterRequest()
    
    var lowerPrice: Double = 100
    var upperPrice: Double = 1000
    var isWholeStore: Bool = false
    var isOfficial: Bool = false
    var isGoldSeller: Bool = false
    var shopType = [ShopTypeModel]()
    
    mutating func reset() {
        lowerPrice = 100
        upperPrice = 1000
        isWholeStore = false
        isOfficial = false
        isGoldSeller = false
        shopType.removeAll()
    }
    
    init() {}
    
}
