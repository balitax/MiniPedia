//
//  InformationProductMock.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import Foundation


struct InformationProductMock {
    var title: String?
    var description: String?
}

extension InformationProductMock {
    
    static func mock() -> [InformationProductMock] {
        return [
            InformationProductMock(title: "Berat", description: "4000 Gram"),
            InformationProductMock(title: "Kondisi", description: "Bekas"),
            InformationProductMock(title: "Asuransi", description: "Ya"),
            InformationProductMock(title: "Pemesanan Min", description: "1 Buah"),
            InformationProductMock(title: "Kategori", description: "Fashion Pria"),
            InformationProductMock(title: "Etalase", description: "Semua Etalase")
        ]
    }
    
}
