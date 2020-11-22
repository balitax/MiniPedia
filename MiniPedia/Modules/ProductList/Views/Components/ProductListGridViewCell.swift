//
//  ProductListGridViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 22/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

class ProductListGridViewCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productStarCount: UILabel!
    @IBOutlet var imgStar: [UIImageView]!
    
    private var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        let rectShape = CAShapeLayer()
        rectShape.frame = self.productImage.bounds
        rectShape.path = UIBezierPath(roundedRect: self.productImage.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.productImage.layer.mask = rectShape
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showAnimatedGradientSkeleton()
        self.containerView.clipsToBounds = true
        self.containerView.cornerRadius = 8
        self.containerView.addShadow(offset: CGSize(width: 1, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor(hexString: "#ededed"), radius: 2, opacity: 0.8)
        
    }
    
    func bindProductData(_ data: DataProducts) {
        
        Delay.wait(delay: 0.5) {
            self.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        }
        
        self.productTitle.text = data.name
        self.productPrice.text = data.price
        if let img_url = URL(string: data.imageURI ?? "") {
            self.productImage.kf.setImage(with: img_url)
        }
        self.productStarCount.text = data.getCountStar
    }
    
}
