//
//  APIClient.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class APIClient {
    
    static let shared = {
        APIClient()
    }()
    
    func requests<T: Codable> (_ endPoint: EndPoint) -> Single<T> {
        
        return Single<T>.create { single in
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: endPoint.urlRequest) { (data, response, error ) in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    single(.error(ApiError.internalServerError))
                    return
                }
                
                if 200..<300 ~= httpResponse.statusCode {
                    guard let data = data else {
                        single(.error(ApiError.invalidData))
                        return
                    }
                    
                    do {
                        let model = try JSONDecoder().decode(
                            T.self, from: data
                        )
                        
                        single(.success(model))
                        
                    } catch let error {
                        single(.error(error))
                        return
                    }
                } else {
                    switch httpResponse.statusCode {
                    case 403:
                        single(.error(ApiError.forbidden))
                    case 404:
                        single(.error(ApiError.notFound))
                    case 409:
                        single(.error(ApiError.conflict))
                    case 500:
                        single(.error(ApiError.internalServerError))
                    default:
                        single(.error(ApiError.internalServerError))
                    }
                }
            }
            
            dataTask.resume()
            
            return Disposables.create {
                dataTask.cancel()
            }
            
        }
        
    }
    
}


























