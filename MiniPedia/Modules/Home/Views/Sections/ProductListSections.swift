//
//  ProductListSections.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 20/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

enum ProductCategory: String, CaseIterable {
    case gadget
    case fashion
    
    func getDescription() -> String {
        switch self {
        case .gadget: return "Gadget Terlaris"
        case .fashion: return "Fashion Paling Dicari"
        }
    }
    
}


class ProductListSections: Sections {
    
    var numberOfItems: Int = 10
    var viewModel: HomeViewViewModel!
    var category: ProductCategory!
    
    private var disposeBag = DisposeBag()
    
    func layoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .estimated(300))
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        
        
        // add header
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "SectionHeaderElementKind",
            alignment: .top
        )
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
        
        
        return section
        
    }
    
    func configureCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCategoryCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.viewModel = viewModel
        return cell
    }
    
    func configureHeaderView(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView {
        let header: HeaderSectionTitleReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: .header, forIndexPath: indexPath)
        header.viewModel = self.viewModel
        header.sectionTitle.text = category.getDescription()
        return header
    }
    
    func reuseIdentifier() -> String {
        return ProductCategoryCollectionViewCell.reuseIdentifier
    }
    
}
