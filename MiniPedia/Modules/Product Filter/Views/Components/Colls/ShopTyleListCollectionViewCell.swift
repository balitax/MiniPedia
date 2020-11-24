//
//  ShopTyleListCollectionViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 09/09/20.
//

import UIKit

protocol ShopTyleListCollectionViewDelegate: class {
    func didDeleteShopType(_ index: Int)
}

class ShopTyleListCollectionViewCell: UICollectionViewCell {
    
    static var idenfier = "ShopTyleListCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ShopTyleListCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var shopType: UILabel!
    
    weak var delegate: ShopTyleListCollectionViewDelegate?
    var tags: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        container.layer.cornerRadius = 14
        container.clipsToBounds = true
        container.layer.borderColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        container.layer.borderWidth = 1
        
    }
    
    @IBAction func didDeleteShopType(_ sender: UIButton) {
        self.delegate?.didDeleteShopType(tags)
    }
    
}
