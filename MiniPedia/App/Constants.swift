//
//  Constants.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

struct Constants {
    //The API's base URL
    static let baseUrl = "https://ace.tokopedia.com/search/v2.5/"
    static var tokopediaBanners = [
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/18/dce6af24-8978-48fc-a379-50cf9136c1ff.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/18/61f648ff-9913-4109-811a-43521a40926b.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/19/dde94860-7ac9-46b7-baeb-2c659b66ce86.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/19/0ccc364c-77ea-4da3-b14c-11f2cb55cb08.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/18/dce6af24-8978-48fc-a379-50cf9136c1ff.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/18/61f648ff-9913-4109-811a-43521a40926b.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/19/dde94860-7ac9-46b7-baeb-2c659b66ce86.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/19/0ccc364c-77ea-4da3-b14c-11f2cb55cb08.jpg"
    ]
}

struct Colors {
    static let greenColor = UIColor(hexString: "#03ac0e")
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

struct Delay {
    
    static func wait(delay: Int = 3, completion: @escaping() -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            completion()
        }
    }
    
}
