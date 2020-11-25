//
//  WhishlistItemsViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 20/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

protocol WhishlistItemsViewDelegate: class {
    func didRemoveWhishlistItem(rows: Int)
    func addToCart(rows: Int)
}


class WhishlistItemsViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var shopLocation: UILabel!
    @IBOutlet weak var productStarCount: UILabel!
    @IBOutlet weak var btnDeleteItem: UIButton!
    @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet var imgStar: [UIImageView]!
    
    private var disposeBag = DisposeBag()
    weak var delegate: WhishlistItemsViewDelegate?
    var rows: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.containerView.clipsToBounds = true
        self.containerView.cornerRadius = 8
        self.containerView.addShadow(offset: CGSize(width: 1, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor(hexString: "#ededed"), radius: 2, opacity: 0.8)
        
        btnDeleteItem
            .rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.delegate?.didRemoveWhishlistItem(rows: self.rows)
            }).disposed(by: disposeBag)
        
        btnAddCart
            .rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.delegate?.addToCart(rows: rows)
            }).disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingData(_ whishlist: ProductStorage) {
        
        if let imgProduct = whishlist.imageURI, let imgURL = URL(string: imgProduct) {
            self.productImage.kf.setImage(with: imgURL)
        }
        
        productTitle.text = whishlist.name
        productPrice.text = whishlist.price
        
        shopLocation.text = whishlist.getShopLocation(id: whishlist.id)
        
        productStarCount.text = "\(whishlist.rating)"
        
        
    }
    
}

extension WhishlistItemsViewCell: Reusable { }
