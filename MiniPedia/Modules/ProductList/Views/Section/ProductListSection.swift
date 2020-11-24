//
//  ProductListSection.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 24/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

class ProductListSection: Sections {
    
    internal var numberOfItems: Int = 6
    private var viewModel: ProductListViewModel!
    private var disposeBag = DisposeBag()
    
    init(viewModel: ProductListViewModel) {
        
        self.viewModel = viewModel
        self.viewModel.getProductList()
        
        viewModel.productDriver
            .asObservable()
            .subscribe(onNext: { [unowned self] product in
                self.numberOfItems = product.count
            }).disposed(by: disposeBag)
        
    }
    
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(310))
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func configureCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ProductListGridViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        if let viewModel = viewModel.items(at: indexPath) {
            cell.viewModel = viewModel
        }
        return cell
        
    }
    
    func reuseIdentifier() -> String {
        ProductListGridViewCell.reuseIdentifier
    }
    
}
