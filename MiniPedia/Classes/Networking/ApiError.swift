//
//  ApiError.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
    case invalidData
    case noInternetConnection
}
