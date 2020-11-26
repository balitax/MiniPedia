//
//  HomeView.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 19/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import SkeletonView
import RxSwift

class HomeView: UIViewController {
    
    @IBOutlet weak var navigationBar: PrimaryNavigationBar!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint! {
        didSet {
            if let height = self.navigationController?.navigationBar.frame.height {
                self.navigationBarHeight.constant = height + 60
            }
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var viewModel: HomeViewViewModel!
    var disposeBag = DisposeBag()
    var sections : [Sections] = []
    lazy var dompetSection = DompetAccountSections(viewModel: self.viewModel)
    
    lazy var fashionSection:  ProductListSections = {
        var product = ProductListSections(viewModel: self.viewModel)
        product.category = .fashion
        return product
    }()
    
    lazy var gadgetSection: ProductListSections = {
        var product = ProductListSections(viewModel: self.viewModel)
        product.category = .gadget
        return product
    }()
    
    lazy var promoSection: ProductListSections = {
        var product = ProductListSections(viewModel: self.viewModel)
        product.category = .promo
        return product
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.bindViewModel()
    }
    
    func bindViewModel() {
        
        viewModel
            .state
            .asObserver()
            .subscribe (onNext: { load in
                switch load {
                case .loading: return
                case .finish:
                    self.collectionView.reloadData()
                default:
                    return
                }
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.numberOfFashionRows, viewModel.numberOfGadgetRows, viewModel.numberOfPromoRows)
            .subscribe(onNext: { [unowned self] fashionRow,gadgetRow,promoRow in
                
                if fashionRow != 0 {
                    self.fashionSection.numberOfItems = fashionRow
                }
                
                if gadgetRow != 0 {
                    self.gadgetSection.numberOfItems = gadgetRow
                }
                
                if promoRow != 0 {
                    self.promoSection.numberOfItems = promoRow
                }
                
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.viewModel.getDetailProduct(indexPath: indexPath)
            }).disposed(by: disposeBag)
        
        navigationBar.searchBarButtonObservable
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.searchProductWithQuery.onNext(())
            }).disposed(by: disposeBag)
        
        collectionView.rx.contentOffset
            .subscribe(onNext: { offset in
                
                let getY = offset.y
                let offset = CGFloat(round(10*getY / 280)/10)
                self.navigationBar.alpaOffset(offset)
                
            }).disposed(by: disposeBag)
        
        navigationBar.whishlistButtonObservable
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.whishlistObservable.onNext(())
            }).disposed(by: disposeBag)
        
        navigationBar.cartButtonObservable
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.cartObservable.onNext(())
            }).disposed(by: disposeBag)
        
    }
    
    fileprivate func setupCollectionView() {
        collectionView.collectionViewLayout = self.collectionViewLayout()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(DompetAccountInfoCollectionViewCell.self)
        collectionView.registerReusableCell(ProductCategoryCollectionViewCell.self)
        collectionView.register(view: FlashBannerView.self, asSupplementaryViewKind: .header)
        collectionView.register(view: HeaderSectionTitleReusableView.self, asSupplementaryViewKind: .header)
        collectionView.reloadData()
        
        self.sections = [
            self.dompetSection,
            self.fashionSection,
            self.gadgetSection,
            self.promoSection
        ]
        
    }
    
    fileprivate func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout{(sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            let section = self.sections[sectionIndex].layoutSection()
            
            if sectionIndex != 0 {
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            } else {
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            }
            
            return section
            
        }
        return layout
    }
    
}

extension HomeView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        sections[indexPath.section].configureCell(collectionView, indexPath: indexPath)
    }
    
    // HEADER FLASH BANNER
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        sections[indexPath.section].configureHeaderView(collectionView, indexPath: indexPath)
    }
    
}
