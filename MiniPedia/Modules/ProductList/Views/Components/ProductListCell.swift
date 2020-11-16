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

    func bindData() {
        self.productLabel.text = viewModel.productName
        self.productPrice.text = viewModel.productPrice
        if let img_url = URL(string: viewModel.productImage ?? "") {
            self.productImage.kf.setImage(with: img_url)
        }
    }
    
    func customUI(_ index: Int, collectionView: UICollectionView) {
        if collectionView.numberOfItems(inSection: 0) % 2 == 0 {
            if index == collectionView.numberOfItems(inSection: 0) - 2 || index == collectionView.numberOfItems(inSection: 0) - 1 {
                self.lineBottom.isHidden = false
            } else {
                self.lineBottom.isHidden = true
            }
        } else {
            if index == collectionView.numberOfItems(inSection: 0) - 1 {
                self.lineBottom.isHidden = false
            } else {
                self.lineBottom.isHidden = true
            }
        }
    }

}
