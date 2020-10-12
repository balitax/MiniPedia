//
//  Constants.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import Foundation

struct Constants {
    //The API's base URL
    static let baseUrl = "https://ace.tokopedia.com/search/v2.5/"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case string = "String"
    
}

enum ContentType: String {
    case json = "Application/json"
    case formEncode = "application/x-www-form-urlencoded"
}

enum RequestParams {
    case body(_: [String: Any])
    case url(_: [String: Any])
}
