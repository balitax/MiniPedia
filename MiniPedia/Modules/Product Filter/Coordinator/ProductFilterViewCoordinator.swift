//
//  ProductFilterViewCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 24/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class ProductFilterViewCoordinator: ReactiveCoordinator<Void> {
    
    public let rootController: UIViewController
    public var viewModel = ProductFilterViewModel()
    public weak var delegate: ProductFilterDelegate?
    
    init(rootViewController: UIViewController, delegate: ProductFilterDelegate, filter: ProductFilterRequest?) {
        self.rootController = rootViewController
        self.delegate = delegate
        
        if let filter = filter {
            self.viewModel.request = filter
        }
    }
    
    override func start() -> Observable<Void> {
        let viewController = ProductFilterView()
        viewController.delegate = delegate
        viewController.viewModel = viewModel
        
        viewController.hidesBottomBarWhenPushed = true
        let embedNavigationController = UINavigationController(rootViewController: viewController)
        embedNavigationController.modalPresentationStyle = .fullScreen
        rootController.present(embedNavigationController, animated: true, completion: nil)
        
        viewModel.merchantTypeDidTap
            .subscribe(onNext: { [unowned self] bindData in
                self.coordinateToMerchantType(viewController, bindData: bindData)
            }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func coordinateToMerchantType(_ rootView: UIViewController, bindData: MerchantTypeBinding) {
        let viewController = MerchantTypeView()
        viewController.delegate = bindData.delegate
        viewController.selectedType = bindData.selected
        let merchantType = UINavigationController(rootViewController: viewController)
        merchantType.modalPresentationStyle = .overCurrentContext
        rootView.present(merchantType, animated: true, completion: nil)
    }
    
}
