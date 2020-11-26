//
//  ShopTypeModel.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 24/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func all(where predicate: (Element) -> Bool) -> [Element]  {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}

struct ShopTypeModel: Identifiable, Equatable {
    
    var id = UUID()
    var typeName: String
    
    static func mock() -> [ShopTypeModel] {
        return [
            ShopTypeModel(typeName: "Gold Merchant"),
            ShopTypeModel(typeName: "Official Store")
        ]
    }
    
    static func isMerchantOfficial(_ data: [ShopTypeModel]) -> Bool {
        let check = data.all(where: { $0.typeName == "Official Store" }).count
        return check == 0 ? false : true
    }
    
    static func isMerchantGold(_ data: [ShopTypeModel]) -> Bool {
        let check = data.all(where: { $0.typeName == "Gold Merchant" }).count
        return check == 0 ? false : true
    }
    
}
