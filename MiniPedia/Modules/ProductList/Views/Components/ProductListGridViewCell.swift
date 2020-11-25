//
//  ProductListGridViewCell.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 22/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift
import SkeletonView

class ProductListGridViewCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productStarCount: UILabel!
    @IBOutlet weak var stackStarContainer: UIStackView!
    @IBOutlet var imgStar: [UIImageView]!
    
    private var disposeBag = DisposeBag()
    
    var viewModel: ProductListCellViewModel! {
        didSet {
            self.bindData()
        }
    }
    
    override func prepareForReuse() {
        
        self.containerView.clipsToBounds = true
        self.containerView.cornerRadius = 8
        
        self.productImage.layoutIfNeeded()
        self.productImage.clipsToBounds = true
        self.productImage.roundCorners(corners: [.topLeft, .topRight], radius: 8)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layoutIfNeeded()
        self.containerView.addShadow(offset: CGSize(width: 1, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor(hexString: "#ededed"), radius: 2, opacity: 0.8)
        
    }
    
    func bindData() {
        self.productTitle.text = viewModel.productName
        self.productPrice.text = viewModel.productPrice
        if let img_url = URL(string: viewModel.productImage ?? "") {
            self.productImage.kf.setImage(with: img_url)
        }
        self.productStarCount.text = viewModel.productStarCount
    }
    
}
