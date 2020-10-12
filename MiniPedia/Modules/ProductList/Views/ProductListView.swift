//
//  ProductListView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

enum ListStyle {
    case list
    case column
}

class ProductListView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.setupCollectionView()
        }
    }
    
    let disposeBag = DisposeBag()
    var viewModel: ProductListViewModel!
    var layout = GridCollectionViewLayout()
    var listStyle = ListStyle.column
    
    lazy var dataSource: RxCollectionViewSectionedReloadDataSource<ProductSection> = {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ProductSection>(configureCell: { (_, collectionView, indexPath, viewModel) -> UICollectionViewCell in
            let cell: ProductListCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.viewModel = viewModel
            cell.customUI(indexPath.row, collectionView: self.collectionView)
            return cell
        })
        return dataSource
    }()
    
    lazy var btnListStyle = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2.fill"), style: .done, target: self, action: #selector(self.didChangeListStyle(_:)))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        self.navigationItem.rightBarButtonItem = btnListStyle
    }
    
    private func setupCollectionView() {
        self.navigationItem.title = "My Product"
        self.collectionView.registerReusableCell(ProductListCell.self)
        self.layout.itemsPerRow = 2
        self.layout.itemSpacing = 0
        self.layout.itemHeightRatio = 1.5/1
        self.collectionView.collectionViewLayout = self.layout
        self.collectionView.reloadData()
    }
    
    @objc
    func didChangeListStyle(_ sender: UIBarButtonItem) {
        if listStyle == .list {
            btnListStyle.image = UIImage(systemName: "rectangle.grid.1x2.fill")
            listStyle = .column
        } else {
            btnListStyle.image = UIImage(systemName: "rectangle.grid.2x2.fill")
            listStyle = .list
        }
        self.changeListStyle(listStyle)
    }
    
    private func bindViewModel() {
        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { state in
                switch state {
                case .loading:
                    self.showLoading()
                case .finish:
                    self.hideLoading()
                default:
                    self.hideLoading()
                }
            }).disposed(by: disposeBag)
        
        viewModel.getProductList()
        
        viewModel.products
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        collectionView.rx.itemSelected
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { indexPath in
                self.collectionView.deselectItem(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(ProductListCellViewModel.self)
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.selectedProduct)
            .disposed(by: disposeBag)
    }
    
    private func changeListStyle(_ style: ListStyle) {
        if style == .list {
            layout.itemsPerRow = 1
            layout.itemSpacing = 0
            layout.itemHeightRatio = 1/1.4
        } else {
            layout.itemsPerRow = 2
            layout.itemSpacing = 0
            layout.itemHeightRatio = 1.5/1
        }
        
        self.collectionView.performBatchUpdates ({
            self.collectionView.reloadData()
        }, completion: nil)
        
    }
    
}
