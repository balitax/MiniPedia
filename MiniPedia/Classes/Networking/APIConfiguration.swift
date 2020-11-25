//
//  APIConfiguration.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import Foundation

protocol APIConfiguration {
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var components: URLComponents { get }
    var urlRequest: URLRequest { get }
}
