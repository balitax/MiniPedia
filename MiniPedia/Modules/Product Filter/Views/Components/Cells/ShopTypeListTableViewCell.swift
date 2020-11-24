//
//  ShopTypeListTableViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 09/09/20.
//

import UIKit

class ShopTypeListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblShopType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        btnCheckBox.isCheckboxTapped(selected)
    }
    
}

extension ShopTypeListTableViewCell: Reusable { }
