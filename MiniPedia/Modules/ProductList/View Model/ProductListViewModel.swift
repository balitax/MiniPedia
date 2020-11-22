//
//  ProductListViewModel.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher

struct ProductSection {
    var header: String
    var items: [ProductListCellViewModel]
}

extension ProductSection: SectionModelType {
    typealias Item = ProductListCellViewModel
    init(original: ProductSection, items: [ProductListCellViewModel]) {
        self = original
        self.items = items
    }
}

class ProductListViewModel: BaseViewModel {
    
    let repository = ProductListRepository()
    var queryProduct = QueryProduct(query: "")
    let selectedProduct = PublishSubject<ProductListCellViewModel>()
    let cartButtonDidTap = PublishSubject<Void>()
    let backButtonDidTap = PublishSubject<Void>()
    
    //MARK: - ViewModel DataSource
    var products = BehaviorRelay<[DataProducts]> (
        value: []
    )
    
    private var _imageProducts = [UIImage]() {
        didSet {
            self.imageProducts.accept(_imageProducts)
        }
    }
    var imageProducts = BehaviorRelay<[UIImage]> (
        value: []
    )
    
    func getProductList() {
        self.state.onNext(.loading)
        repository.getProductList(queryProduct)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { products in
                self.products.accept(products.data)
                self.state.onNext(.finish)
            }, onError: { error in
                self.state.onNext(.error)
            }).disposed(by: disposeBag)
    }
    
    func imageDownloadFromURL(_ url: String) {
        guard let toURL = URL(string: url) else { return }
        let downloader = ImageDownloader.default
        downloader.downloadImage(with: toURL, completionHandler:  { [weak self] result in
            guard let self = `self` else { return }
            switch result {
            case .success(let value):
                let img = value.image
                self._imageProducts.append(img)
            case .failure(let error):
                print("ERROR ", error.localizedDescription)
            }
        })
            
    }
    
}






























