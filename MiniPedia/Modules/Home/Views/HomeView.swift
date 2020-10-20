//
//  HomeView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 19/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import SkeletonView
import RxSwift

class HomeView: UIViewController {
    
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: HomeViewViewModel!
    var disposeBag = DisposeBag()
    var sections : [Sections] = []
    lazy var dompetSection = DompetAccountSections(viewModel: self.viewModel)
    
    lazy var gadgetSection:  ProductListSections = {
        var product = ProductListSections()
        product.viewModel = self.viewModel
        product.category = .fashion
        return product
    }()
    
    lazy var fashionSection: ProductListSections = {
        var product = ProductListSections()
        product.viewModel = self.viewModel
        product.category = .gadget
        return product
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    func bindViewModel() {
        
        self.collectionView.reloadData()
        self.view.showAnimatedSkeleton()
        
        self.viewModel.loaded.onNext(false)
        self.sections = [
            self.dompetSection,
            self.gadgetSection,
            self.fashionSection
        ]
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.viewModel.loaded.onNext(true)
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        }
        self.setupCollectionView()
        
    }
    
    fileprivate func setupCollectionView() {
        collectionView.collectionViewLayout = self.collectionViewLayout()
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(DompetAccountInfoCollectionViewCell.self)
        collectionView.registerReusableCell(ProductCategoryCollectionViewCell.self)
        collectionView.register(view: FlashBannerView.self, asSupplementaryViewKind: .header)
        collectionView.register(view: HeaderSectionTitleReusableView.self, asSupplementaryViewKind: .header)
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

extension HomeView: UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout { }

extension HomeView: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return DompetAccountInfoCollectionViewCell.reuseIdentifier
    }
    
}
