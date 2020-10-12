//
//  APIClient.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift
import RxAlamofire
import Alamofire


class APIClient {
    
    static let shared = {
        APIClient()
    }()
    
    func requests<T: Codable> (_ endPoint: EndPoint) -> Observable<T> {
        
        return Observable<T>.create { observer in
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: endPoint.urlRequest) { (data, response, error ) in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(ApiError.internalServerError)
                    return
                }
                
                if 200..<300 ~= httpResponse.statusCode {
                    guard let data = data else {
                        observer.onError(ApiError.invalidData)
                        return
                    }
                    
                    do {
                        let model = try JSONDecoder().decode(
                            T.self, from: data
                        )
                        
                        observer.onNext(model)
                        observer.onCompleted()
                        
                    } catch let error {
                        observer.onError(error)
                        return
                    }
                } else {
                    switch httpResponse.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(ApiError.internalServerError)
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


























