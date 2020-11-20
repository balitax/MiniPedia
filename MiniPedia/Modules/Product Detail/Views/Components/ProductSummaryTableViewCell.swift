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
import FaveButton

class ProductSummaryTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var btnFavorite: FaveButton!
    @IBOutlet weak var productStock: UILabel!
    
    @IBOutlet weak var starCount: UILabel!
    @IBOutlet weak var ratingCount: UILabel!
    
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var soldCount: UILabel!
    @IBOutlet weak var merchantName: UILabel!
    
    @IBOutlet weak var stackViewContainer: UIStackView!
    
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
        
        self.btnFavorite?.setSelected(selected: true, animated: false)
        self.btnFavorite?.setSelected(selected: false, animated: false)
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

extension ProductSummaryTableViewCell: FaveButtonDelegate {
    
    func color(_ rgbColor: Int) -> UIColor{
        return UIColor(
            red:   CGFloat((rgbColor & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbColor & 0x00FF00) >> 8 ) / 255.0,
            blue:  CGFloat((rgbColor & 0x0000FF) >> 0 ) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        
        let colors = [
            DotColors(first: color(0x7DC2F4), second: color(0xE2264D)),
            DotColors(first: color(0xF8CC61), second: color(0x9BDFBA)),
            DotColors(first: color(0xAF90F4), second: color(0x90D1F9)),
            DotColors(first: color(0xE9A966), second: color(0xF8C852)),
            DotColors(first: color(0xF68FA7), second: color(0xF6A2B8))
        ]
        
        if( faveButton === btnFavorite){
            return colors
        }
        return nil
    }
    
}
