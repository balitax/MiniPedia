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
    
    deinit {
        print("#\(self)")
    }
    
    init() {
        super.init(nibName: "ProductListView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chipsMenu: ChipsMenuView!
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
    var listStyle = ListStyle.column
    lazy var refreshHandler = RefreshHandler(view: collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
    }
    
    private func setupCollectionView() {
        self.collectionView.registerReusableCell(ProductListGridViewCell.self)
        
        if let layout = collectionView?.collectionViewLayout as? WaterfallFlowLayout {
            layout.delegate = self
        }
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.collectionView.keyboardDismissMode = .onDrag
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
    
    private func bindViewModel() {
        
        let menu = ["DKI Jakarta", "Surabaya", "Elektronik", "Kebutuhan Rumah", "Kesehatan", "Makanan & Minuman", "Fashion Pria", "Fashion Wanita"]
        self.chipsMenu.items = menu
        
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
                    self.collectionView.reloadData()
                    self.hideLoading()
                default:
                    self.hideLoading()
                }
            }).disposed(by: disposeBag)
        
        viewModel.products
            .asObservable()
            .subscribe(onNext: { [weak self] products in
                guard let self = self else { return }
                for img in products {
                    if let imgProduct = img.imageURI700 {
                        self.viewModel.imageDownloadFromURL(imgProduct)
                    }
                }
            }).disposed(by: disposeBag)
        
        viewModel.imageProducts
            .asObservable()
            .subscribe(onNext: { [weak self] products in
                print("GAMBARE ", products.map { $0.size.height })
                self?.collectionView.performBatchUpdates({
                    self?.collectionView.reloadData()
                }, completion: { _ in
                    
                })
            }).disposed(by: disposeBag)
        
        //        viewModel.products
        //            .asObserver()
        //            .catchErrorJustReturn([])
        //            .observeOn(MainScheduler.instance)
        //            .bind(to: collectionView.rx.items(dataSource: self.dataSource))
        //            .disposed(by: self.disposeBag)
        
        //        viewModel.products
        //            .asObserver()
        //            .subscribe(onNext: {[unowned self] _ in
        //                self.refreshHandler.end()
        //            }, onError: { error in
        //                self.refreshHandler.end()
        //                self.showAlert(error.localizedDescription, type: .error)
        //            }).disposed(by: disposeBag)
        
//        collectionView.rx.itemSelected
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] indexPath in
//                self.collectionView.deselectItem(at: indexPath, animated: true)
//            }).disposed(by: disposeBag)
        
//        collectionView.rx.modelSelected(ProductListCellViewModel.self)
//            .observeOn(MainScheduler.instance)
//            .bind(to: viewModel.selectedProduct)
//            .disposed(by: disposeBag)
        
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
        
        navigationBar.cartButtonObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] pip in
                self.viewModel.cartButtonDidTap.onNext(())
            }).disposed(by: disposeBag)
        
        
        navigationBar.enableShareButton = false
        
        if let title = viewModel.queryProduct.titleProduct {
            if !title.isEmpty {
                navigationBar.titleOnSearchBar = title
            } else {
                navigationBar.title = "All Products"
            }
        }
        
        navigationBar.searchProductObservable
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.queryProduct = QueryProduct(query: text)
                self?.viewModel.getProductList()
            }).disposed(by: disposeBag)
        
        navigationBar.alpaOffset(1)
        
    }
    
}

extension ProductListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ProductListGridViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.bindProductData(viewModel.products.value[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 20)) / 2
      return CGSize(width: itemSize, height: itemSize)
    }
    
}

extension ProductListView: WaterfallFlowLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      heightForImageAtIndexPath indexPath:IndexPath) -> CGFloat {
    if viewModel.imageProducts.value.isEmpty {
        return 0
    } else {
        return viewModel.imageProducts.value[indexPath.row].size.height
    }
  }
}
