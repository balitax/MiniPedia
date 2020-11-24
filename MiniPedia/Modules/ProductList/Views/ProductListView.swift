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
import SkeletonView

class ProductListView: UIViewController {
    
    deinit {
        print("#\(self)")
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
    @IBOutlet weak var filterContainer: UIView!
    @IBOutlet weak var filterContainerMarginBottom: NSLayoutConstraint!
    @IBOutlet weak var filterButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: ProductListViewModel!
    var sections : [Sections] = []
    private var filterData: ProductFilterRequest?
    lazy var refreshHandler = RefreshHandler(view: collectionView)
    lazy var productListSection = ProductListSection(viewModel: self.viewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        view.layoutSkeletonIfNeeded()
    }
    
    private func setupCollectionView() {
        self.collectionView.collectionViewLayout = self.collectionViewLayout()
        self.collectionView.registerReusableCell(ProductListGridViewCell.self)
        self.collectionView.backgroundColor = .systemGroupedBackground
        self.collectionView.keyboardDismissMode = .onDrag
        self.collectionView.dataSource = self
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.reloadData()
        
        self.sections = [
            self.productListSection
        ]
        
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        
        self.filterContainer.clipsToBounds = true
        self.filterContainer.cornerRadius = 24
    }
    
    private func reloadOnFinish() {
        Delay.wait(delay: 1) {
            self.refreshHandler.end()
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
        }
    }
    
    private func bindViewModel() {
        
        let menu = ["DKI Jakarta", "Surabaya", "Elektronik", "Kebutuhan Rumah", "Kesehatan", "Makanan & Minuman", "Fashion Pria", "Fashion Wanita"]
        self.chipsMenu.items = menu
        
        viewModel
            .state
            .asObserver()
            .subscribe (onNext: { load in
                switch load {
                case .loading:
                    self.collectionView.showAnimatedGradientSkeleton()
                case .finish:
                    self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
                default:
                    return
                }
            }).disposed(by: disposeBag)
        
        viewModel.productDriver
            .asObservable()
            .subscribe(onNext: { [unowned self] product in
                self.reloadOnFinish()
                if !product.isEmpty {
                    self.showFilterContainer(true)
                }
            }).disposed(by: disposeBag)
        
        if viewModel.queryProduct.query.isEmpty {
            navigationBar.setAutoFocus()
        }
        
        collectionView.rx.itemSelected
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] indexPath in
                self.viewModel.selectedItem(at: indexPath)
                self.collectionView.deselectItem(at: indexPath, animated: true)
            }).disposed(by: disposeBag)

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
        
        filterButton
            .rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                let filter = ProductFilterBinding(delegate: self, filter: filterData)
                self.viewModel.filterButtonDidTap.onNext(filter)
            }).disposed(by: disposeBag)
        
    }
    
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout{(sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            let section = self.sections[sectionIndex].layoutSection()
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
            return section
        }
        return layout
    }
    
    private func showFilterContainer(_ show: Bool) {
        let valueHide: CGFloat = -100
        let valueShow: CGFloat = 24
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 10,
                       options: [.curveEaseOut],
                       animations: {
                        self.filterContainerMarginBottom.constant = show ? valueShow : valueHide
                        self.view.layoutIfNeeded()
                       }, completion: nil)
    }
    
}

extension ProductListView: ProductFilterDelegate {
    
    func didApplyFilter(_ filter: ProductFilterRequest?) {
        if let request = filter {
            self.filterData = filter
            viewModel.queryProduct.store(request)
            viewModel.getProductList()
        }
    }
    
}

extension ProductListView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        sections[indexPath.section].configureCell(collectionView, indexPath: indexPath)
    }
    
}


extension ProductListView: SkeletonCollectionViewDataSource {
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ProductListGridViewCell.reuseIdentifier
    }
    
}
