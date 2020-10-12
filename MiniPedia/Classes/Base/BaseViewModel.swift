//
//  BaseViewModel.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 08/09/20.
//

import RxSwift
import RxCocoa

enum NetworkState {
    case initial
    case loading
    case finish
    case error
}

class BaseViewModel {
    
    let disposeBag = DisposeBag()
    var state = PublishSubject<NetworkState>()
    
}
