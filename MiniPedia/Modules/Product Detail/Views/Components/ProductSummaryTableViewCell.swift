//
//  ProductSummaryTableViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

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
    
    @IBOutlet weak var stackViewContainer: UIStackView!
    
    
    let gradient: CAGradientLayer = CAGradientLayer()
    
    var viewModel: ProductDetailViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.configureCell()
            }
        }
    }
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let colors = [
            UIColor.darkGray.cgColor,
            UIColor.clear.cgColor]
        gradient.frame = bounds
        gradient.colors = colors
        gradient.locations = [0.0, 0.6]
        productImage.layer.insertSublayer(gradient, at: 0)
        
        self.productTitle.setLineHeight(lineHeight: 4.0)
        
        _ = [
            self.productTitle,
            self.productPrice,
            self.productStock,
            self.ratingCount,
            self.reviewsCount,
            self.soldCount,
            self.merchantName
        ].map {
            $0?.text = "                    "
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func configureCell() {
        
        _ = viewModel.products
            .asObservable()
            .subscribe(onNext: {[ weak self ] product in
                guard let self = self else { return }
                guard let data = product else { return }
                
                self.productTitle.text = data.name
                self.productPrice.text = data.price
                if let imgProduct = data.imageURI700, let imgURL = URL(string: imgProduct) {
                    self.productImage.kf.setImage(with: imgURL)
                }
                
                self.productStock.attributedText = data.getStock
                self.ratingCount.text = "(\(data.rating ?? 0))"
                self.reviewsCount.text = "\(data.countReview ?? 0)"
                self.soldCount.text = data.getCountSold
                self.merchantName.text = data.shop?.name
                
            }).disposed(by: disposeBag)
        
        self.stackViewContainer.layoutIfNeeded()
    }
    
}
