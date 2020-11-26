//
//  ProductDetailCoordinator.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

class ProductDetailCoordinator: ReactiveCoordinator<Void> {
    
    public let rootViewController: UIViewController
    public var viewModel: ProductListCellViewModel!
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
    
        let viewController          = ProductDetailView()
        let detailViewModel         = ProductDetailViewModel()
        
        detailViewModel.products.onNext(viewModel.product)
        viewController.viewModel    = detailViewModel
        
        viewController.hidesBottomBarWhenPushed = true
        rootViewController.navigationController?
            .pushViewController(viewController, animated: true)
        
        detailViewModel.cartButtonDidTap
            .subscribe(onNext: { [unowned self] _ in
                self.coordinateToCart()
            })
            .disposed(by: disposeBag)
        
        detailViewModel.urlToko
            .subscribe(onNext: { [unowned self] url in
                self.`self`()
                UIApplication.shared.open(url)
            }).disposed(by: disposeBag)
        
        detailViewModel.shareThisProduct
            .subscribe(onNext: { [unowned self] url in
                let objectsToShare = [url]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                self.rootViewController.present(activityVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        
        detailViewModel.backButtonDidTap
            .subscribe(onNext: { [unowned self] _ in
                self.rootViewController.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        return Observable.never()
        
    }
    
    private func coordinateToCart() {
        rootViewController.navigationController?.popToRootViewController(animated: true)
        Delay.wait(delay: 1) {
            self.rootViewController.tabBarController?.selectedIndex = 1
        }
    }
    
}
