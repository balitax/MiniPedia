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
    
    init() {
        super.init(nibName: "ProductListView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationBar: SecondaryNavigationBar!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint! {
        didSet {
            if let height = self.navigationController?.navigationBar.frame.height {
                self.navigationBarHeight.constant = height + 50
            }
        }
    }
    
    let disposeBag = DisposeBag()
    var viewModel: ProductListViewModel!
    var layout = GridCollectionViewLayout()
    var listStyle = ListStyle.column
    lazy var refreshHandler = RefreshHandler(view: collectionView)
    
    lazy var dataSource: RxCollectionViewSectionedReloadDataSource<ProductSection> = {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ProductSection>(configureCell: { (_, collectionView, indexPath, viewModel) -> UICollectionViewCell in
            let cell: ProductListCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.viewModel = viewModel
            cell.customUI(indexPath.row, collectionView: self.collectionView)
            return cell
        })
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
    }
    
    private func setupCollectionView() {
        self.collectionView.registerReusableCell(ProductListCell.self)
        self.layout.itemsPerRow = 2
        self.layout.itemSpacing = 0
        self.layout.itemHeightRatio = 1.5/1
        self.collectionView.collectionViewLayout = self.layout
        self.collectionView.keyboardDismissMode = .onDrag
        self.collectionView.reloadData()
    }
    
    private func bindViewModel() {
        
        if !viewModel.queryProduct.query.isEmpty {
            viewModel.getProductList()
        } else {
            navigationBar.setAutoFocus()
        }
        
        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in
                switch state {
                case .loading:
                    self.showLoading()
                case .finish:
                    self.hideLoading()
                default:
                    self.hideLoading()
                }
            }).disposed(by: disposeBag)
        
        viewModel.products
            .asObserver()
            .catchErrorJustReturn([])
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        viewModel.products
            .asObserver()
            .subscribe(onNext: {[unowned self] _ in
                self.refreshHandler.end()
            }, onError: { error in
                self.refreshHandler.end()
                self.showAlert(error.localizedDescription, type: .error)
            }).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] indexPath in
                self.collectionView.deselectItem(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(ProductListCellViewModel.self)
            .observeOn(MainScheduler.instance)
            .bind(to: viewModel.selectedProduct)
            .disposed(by: disposeBag)
        
        if !viewModel.queryProduct.query.isEmpty {
            refreshHandler.refresh
                .startWith(())
                .asObservable()
                .subscribe(onNext: { [unowned self] in
                    self.viewModel.getProductList()
                }).disposed(by: disposeBag)
            
        }
        
        
        
        navigationBar.leftButtonObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] pip in
                self.viewModel.backButtonDidTap.onNext(())
            }).disposed(by: disposeBag)
        
//        navigationBar.cartButtonObservable
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] pip in
//                self.viewModel.cartButtonDidTap.onNext(())
//            }).disposed(by: disposeBag)
        
        
        navigationBar.enableShareButton = false
        navigationBar.titleOnSearchBar = viewModel.queryProduct.titleProduct ?? ""
        
        navigationBar.searchProductObservable
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.queryProduct = QueryProduct(query: text)
                self?.viewModel.getProductList()
            }).disposed(by: disposeBag)
        
    }
    
}
