//
//  Products.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 07/09/20.
//

import Foundation


// MARK: - Products
struct Products: Codable, Identifiable {
    var id = UUID()
    let status: Status
    let header: Header
    let data: [DataProducts]
    let category: Category
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case header = "header"
        case data = "data"
        case category = "category"
    }
    
}

// MARK: - Category
struct Category: Codable {
    let data: [String: ProductValue]
    let selectedID: String

    enum CodingKeys: String, CodingKey {
        case data
        case selectedID = "selected_id"
    }
}

// MARK: - DatumValue
struct ProductValue: Codable {
    
    var id: Int
    var name, totalData: String
    var parentID: Int
    var childID: [Int]?
    var level: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case totalData = "total_data"
        case parentID = "parent_id"
        case childID = "child_id"
        case level
    }
    
}

// MARK: - DatumElement
struct DataProducts: Codable {
    
    var id: Int?
    var name: String?
    var uri: String?
    var imageURI, imageURI700: String?
    var price, priceRange, categoryBreadcrumb: String?
    var shop: Shop?
    var condition, preorder, departmentID, rating: Int?
    var isFeatured, countReview, countTalk, countSold: Int?
    var originalPrice, discountExpired, discountStart: String?
    var discountPercentage, stock: Int?
    
    init() {}
    
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

    enum CodingKeys: String, CodingKey {
        case id, name, uri
        case imageURI = "image_uri"
        case imageURI700 = "image_uri_700"
        case price
        case priceRange = "price_range"
        case categoryBreadcrumb = "category_breadcrumb"
        case shop
        case condition, preorder
        case departmentID = "department_id"
        case rating
        case isFeatured = "is_featured"
        case countReview = "count_review"
        case countTalk = "count_talk"
        case countSold = "count_sold"
        case originalPrice = "original_price"
        case discountExpired = "discount_expired"
        case discountStart = "discount_start"
        case discountPercentage = "discount_percentage"
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

enum Color: String, Codable {
    case ffffff = "#ffffff"
    case the42B549 = "#42b549"
}

enum LabelTitle: String, Codable {
    case gratisOngkir = "Gratis Ongkir"
    case grosir = "Grosir"
}

// MARK: - Shop
class Shop: NSObject, Codable {
    
    required override init() {
        
    }
    
    let uuid = UUID().uuidString
    var id: Int?
    var name: String?
    var uri: String?
    var isGold: Int?
    var location: String?
    var reputationImageURI, shopLucky: String?
    var city: String?
    var isPowerBadge: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, uri
        case isGold = "is_gold"
        case location
        case reputationImageURI = "reputation_image_uri"
        case shopLucky = "shop_lucky"
        case city
        case isPowerBadge = "is_power_badge"
    }
    
    static func primaryKey() -> String? {
        return "uuid"
    }
}

// MARK: - Header
struct Header: Codable {
    let totalData, totalDataNoCategory: Int
    let additionalParams: String
    let processTime: Double

    enum CodingKeys: String, CodingKey {
        case totalData = "total_data"
        case totalDataNoCategory = "total_data_no_category"
        case additionalParams = "additional_params"
        case processTime = "process_time"
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
    var query: String
    var minPrice: Double?
    var maxPrice: Double?
    var isWholeStore: Bool?
    var isOfficial: Bool?
    var goldMerchant: Bool?
    var start: Int = 0
    var rows: Int = 20
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
