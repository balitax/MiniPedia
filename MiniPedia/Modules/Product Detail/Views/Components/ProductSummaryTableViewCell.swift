//
//  ProductSummaryTableViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import Kingfisher

class ProductSummaryTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var productStock: UILabel!
    
    @IBOutlet weak var starCount: UILabel!
    @IBOutlet weak var ratingCount: UILabel!
    
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var soldCount: UILabel!
    @IBOutlet weak var merchantName: UILabel!
    
    
    var viewModel: ProductDetailViewModel! {
        didSet {
            self.configureCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureCell() {
        self.productTitle.text = viewModel.product?.name
        self.productPrice.text = viewModel.product?.price
        
        if let imgProduct = viewModel.product?.imageURI700, let imgURL = URL(string: imgProduct) {
            self.productImage.kf.setImage(with: imgURL)
        }
        
        self.productStock.attributedText = viewModel.product?.getStock
        self.ratingCount.text = "(\(viewModel.product?.rating ?? 0))"
        self.reviewsCount.text = "\(viewModel.product?.countReview ?? 0)"
        self.soldCount.text = viewModel.product?.getCountSold
        self.merchantName.text = viewModel.product?.shop.name
        
    }
    
}
