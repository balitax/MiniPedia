//
//  ChipsMenuView.swift
//  tenantapp
//
//  Created by Agus RoomMe on 21/10/20.
//  Copyright © 2020 RoomMe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

protocol ChipsMenuDelegate: class {
    func didSelectedMenu(id: Int?, name: String?, slug: String?)
}

class ChipsMenuView: UIView {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    weak var delegate: ChipsMenuDelegate?
    
    private static let NIB_NAME = "ChipsMenuView"
    
    public var items = [String]() {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
                self.collectionView.reloadData()
                self.defaultSelectedCell()
            }
        }
    }
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }
    
    private func nibSetup() {
        Bundle.main.loadNibNamed(ChipsMenuView.NIB_NAME, owner: self, options: nil)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        NSLayoutConstraint.activate(
            [
                containerView.topAnchor.constraint(equalTo: topAnchor),
                containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                containerView.heightAnchor.constraint(equalToConstant: 40)
            ]
        )
        
        setupCollectionView()
        
    }
    
    private func setupCollectionView() {
        collectionView.registerReusableCell(ChipsMenuItemCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showAnimatedSkeleton()
        collectionView.reloadData()
        
        if let layout = collectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.estimatedItemSize = CGSize(width: 40, height: 26)
            collectionView.collectionViewLayout = layout
        }
        
        // ----
//        collectionView.rx.itemSelected
//            .subscribe(onNext: { [unowned self] indexPath in
//
//                let data = self.items[indexPath.row]
//                self.delegate?.didSelectedMenu(
//                    id: data.arcatID,
//                    name: data.arcatName,
//                    slug: data.arcatSlug)
//
//                let cell = self.collectionView.cellForItem(at:
//                    indexPath) as? ChipsMenuItemCell
//                cell?.setSelected()
//                self.collectionView.scrollToItem(at: indexPath,
//                                                 at: .centeredHorizontally, animated: true)
//            }).disposed(by: disposeBag)
        
        // ----
        collectionView.rx.itemDeselected
            .subscribe(onNext: { [unowned self] indexPath in
                let cell = self.collectionView.cellForItem(at: indexPath) as? ChipsMenuItemCell
                cell?.setUnselected()

            }).disposed(by: disposeBag)
        
    }
    
    private func defaultSelectedCell() {
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
    
}

extension ChipsMenuView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChipsMenuItemCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(items[indexPath.row], maxWidth: collectionView.bounds.width)
        cell.hideSkeleton()
        return cell
    }
    
}


extension ChipsMenuView: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ChipsMenuItemCell.reuseIdentifier
    }
    
}
