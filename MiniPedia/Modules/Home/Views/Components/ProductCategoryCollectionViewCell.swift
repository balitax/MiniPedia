//
//  ProductCategoryCollectionViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 20/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

class ProductCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    
    var viewModel: HomeViewViewModel! {
        didSet {
            configureCell()
        }
    }
    
    private var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        let rectShape = CAShapeLayer()
        rectShape.frame = self.productImage.bounds
        rectShape.path = UIBezierPath(roundedRect: self.productImage.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.productImage.layer.mask = rectShape
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layoutIfNeeded()
        
        self.showAnimatedSkeleton()
        
        self.containerView.clipsToBounds = true
        self.containerView.cornerRadius = 8
        self.containerView.addShadow(offset: CGSize(width: 1, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor(hexString: "#ededed"), radius: 2, opacity: 0.8)
        
    }
    
    private func configureCell() {
        viewModel.loaded.asObserver()
            .subscribe(onNext: { [unowned self] loaded in
                if loaded {
                    self.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
                    self.productTitle.text = "OVJ : Eps. Kabayan Pengen Ngetop ( 20 Feb 2013 )"
                } else {
                    self.showAnimatedSkeleton()
                }
            }).disposed(by: self.disposeBag)
        
    }
    
}

extension ProductCategoryCollectionViewCell: Reusable {}
