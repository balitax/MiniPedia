//
//  Sections.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 20/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

protocol Sections {
    var numberOfItems: Int { get }
    func layoutSection() -> NSCollectionLayoutSection
    func configureCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func configureHeaderView(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView
    func reuseIdentifier() -> String
}


extension Sections {
    func configureHeaderView(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
}
