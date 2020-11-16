//
//  CartCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 15/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class CartCoordinator: ReactiveCoordinator<Void> {
    
    public let rootViewController: UIViewController
    public var viewModel = CartViewModel()
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        
        let viewController          = self.rootViewController as! CartView
        viewController.viewModel    = viewModel
        
        viewModel.deleteAllCartObservable
            .flatMapLatest({ [unowned self] _ in
                return self.coordinatePopupConfirmUI()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.buyNowObservable
            .subscribe(onNext: { [unowned self] _ in
                rootViewController.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        return Observable.never()
        
    }
    
    private func coordinatePopupConfirmUI() -> Observable<Void> {
        let popupCoordinator = PopupConfirmationCoordinator(rootViewController: rootViewController)
        popupCoordinator.delegate = self
        popupCoordinator.confirmType = .cartDelete
        return coordinate(to: popupCoordinator)
            .map { _ in () }
    }
    
}

extension CartCoordinator: ConfirmPopupViewDelegate {

    func didItCancel() {
        // nothink todo
    }

    func didItConfirm() {
        // delete cart
        viewModel.didDeleteAllCart()
    }

}
