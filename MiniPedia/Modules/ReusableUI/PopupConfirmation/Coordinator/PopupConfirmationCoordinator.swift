//
//  PopupConfirmationCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 17/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class PopupConfirmationCoordinator: ReactiveCoordinator<Void> {
    
    public let rootViewController: UIViewController
    public var delegate: ConfirmPopupViewDelegate!
    public var confirmType: PopupConfirmType!
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        let viewController          = PopupConfirmationView()
        viewController.delegate     = delegate
        viewController.confirmType  = confirmType
        rootViewController.present(viewController, animated: true, completion: nil)
        return Observable.never()
        
    }
    
}
