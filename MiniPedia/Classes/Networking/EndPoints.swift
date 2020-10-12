//
//  EndPoint.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import Foundation

enum EndPoint: APIConfiguration {
    
    // MARK: - Endpoint API
    case getProducts(_ query: QueryProduct)
    
    // MARK: -- Path
    internal var path: String {
        switch self {
        case .getProducts( _):
            return "product"
        }
    }
    
    // MARK: -- BaseURL with Path Components
    internal var baseURL: URL {
        switch self {
        case .getProducts( _):
            let url = URL(string: Constants.baseUrl)!
            let baseURL = url.appendingPathComponent(path)
            return baseURL
        }
    }
    
    // MARK: -- Query Items / Parameters
    internal var queryItems: [URLQueryItem]? {
        switch self {
        case .getProducts( _):
            let query = components.queryItems
            return query
        }
    }
    
    // MARK: -- URL Components / Parameters
    internal var components: URLComponents {
        switch self {
        case .getProducts( let query):
            
            guard var components =  URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
                fatalError("Couldn't create URLComponents")
            }
            
            components.queryItems = query.toURLQuery()
            
            return components
        }
    }
    
    // MARK: -- URL Request
    var urlRequest: URLRequest {
        switch self {
        case .getProducts( _):
            let request = URLRequest(url: components.url!)
            return request
        }
    }
    
}
