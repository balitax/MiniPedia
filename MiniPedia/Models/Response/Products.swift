//
//  Products.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 07/09/20.
//

import Foundation

// MARK: - Products
struct Products: Codable, Identifiable {
    
    var id: String = UUID().uuidString
    let status: Status
    let data: [DataProducts]
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
    
}

// MARK: - DatumElement
struct DataProducts: Codable, Identifiable {
    
    var id: Int?
    var name: String?
    var uri: String?
    var imageURI, imageURI700: String?
    var price: String?
    var shop: Shop?
    var rating: Int?
    var countReview, countSold: Int?
    var discountPercentage, stock: Int?
    
    var getStock: NSMutableAttributedString? {
        var attributedString = NSMutableAttributedString()
        let onStock = stock ?? 0
        if onStock <= 10 {
            attributedString = NSMutableAttributedString()
                .normal("Stok ", fontSize: 12)
                .bold("tersisa <\(onStock), ", fontSize: 12)
                .normal("beli segera!", fontSize: 12)
        } else {
            attributedString = NSMutableAttributedString()
                .normal("Stok ", fontSize: 12)
                .bold("tersisa \(onStock), ", fontSize: 12)
                .normal("ayo belanja sekarang!", fontSize: 12)
        }
        return attributedString
    }
    
    var getCountSold: String? {
        return "Terjual \(countSold ?? 0)"
    }
    
    var getCountStar: String? {
        return "\(rating ?? 0)"
    }

    enum CodingKeys: String, CodingKey {
        case id, name, uri
        case imageURI = "image_uri"
        case imageURI700 = "image_uri_700"
        case price
        case shop
        case rating
        case countReview = "count_review"
        case countSold = "count_sold"
        case stock
    }

    static func primaryKey() -> String? {
        return "uuid"
    }
    
    
}

extension DataProducts: Equatable {
    
    static func == (lhs: DataProducts, rhs: DataProducts) -> Bool {
        return lhs.id == rhs.id
    }
    
}

// MARK: - Shop
struct Shop: Codable {
    
    let uuid = UUID().uuidString
    var id: Int?
    var name: String?
    var uri: String?
    var location: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, uri, location
    }
    
}

// MARK: - Status
struct Status: Codable {
    let errorCode: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message
    }
}

// MARK: Query Product
struct QueryProduct {
    
    var titleProduct: String?
    var query: String
    var minPrice: Double?
    var maxPrice: Double?
    var isWholeStore: Bool?
    var isOfficial: Bool?
    var goldMerchant: Bool?
    var start: Int = 0
    var rows: Int = 20
    
    mutating func store(_ request: ProductFilterRequest) {
        self.minPrice = request.lowerPrice
        self.maxPrice = request.upperPrice
        self.isWholeStore = request.isWholeStore
        self.isOfficial = request.isOfficial
        self.goldMerchant = request.isGoldSeller
    }
    
}

extension QueryProduct {
    private func toParameters() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["q"] = query
        dictionary["pmin"] = minPrice
        dictionary["pmax"] =  maxPrice
        dictionary["wholesale"] = isWholeStore
        dictionary["official"] = isOfficial
        dictionary["fshop"] = goldMerchant
        dictionary["start"] = start
        dictionary["rows"] = rows
        return dictionary
    }
    
    func toURLQuery() -> [URLQueryItem] {
        return self.toParameters().map {
            URLQueryItem(name: $0.0, value: "\($0.1)")
        }
    }
}
