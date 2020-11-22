//
//  WhishlistItemsViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 20/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.containerView.clipsToBounds = true
        self.containerView.cornerRadius = 8
        self.containerView.addShadow(offset: CGSize(width: 1, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor(hexString: "#ededed"), radius: 2, opacity: 0.8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension WhishlistItemsViewCell: Reusable { }
