//
//  ProductListView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

class ProductListView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    var viewModel: ProductListViewModel!
    var layout = GridCollectionViewLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
    }
    
    private func setupCollectionView() {
        self.navigationItem.title = "My Product"
        self.collectionView.registerReusableCell(ProductListCell.self)
        layout.itemsPerRow = 2
        layout.itemSpacing = 0
        layout.itemHeightRatio = 1.5/1
        self.collectionView.collectionViewLayout = layout
        self.collectionView.reloadData()
        
        let relaodButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.didReloadData(_:)))
        self.navigationItem.rightBarButtonItem = relaodButton
        
    }
    
    @objc
    func didReloadData(_ sender: UIBarButtonItem) {
        self.viewModel.getProductList()
    }
    
    private func bindViewModel() {
        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { state in
                switch state {
                case .loading:
                    self.showProgress()
                case .finish:
                    self.hideProgress()
                default:
                    self.hideProgress()
                }
            }).disposed(by: disposeBag)
        
        viewModel.getProductList()
        
        viewModel.products
            .bind(to: collectionView.rx.items(cellIdentifier: ProductListCell.reuseIdentifier, cellType: ProductListCell.self)) { index, viewModels, cell in
                cell.viewModel = viewModels
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.collectionView.deselectItem(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
        
        
        
    }


}
