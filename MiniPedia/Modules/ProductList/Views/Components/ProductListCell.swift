//
//  ProductListCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 08/09/20.
//

import UIKit
import Kingfisher

class ProductListCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var border: UIView!
    @IBOutlet weak var lineBottom: UIView!
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    
    var viewModel: ProductListCellViewModel! {
        didSet {
            self.bindData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        self.productImage.image = nil
        self.productLabel.text = nil
        self.productPrice.text = nil
    }
    
    func bindData() {
        self.productLabel.text = viewModel.productName
        self.productPrice.text = viewModel.productPrice
        if let img_url = URL(string: viewModel.productImage) {
            self.productImage.kf.setImage(with: img_url)
        }
    }

}
