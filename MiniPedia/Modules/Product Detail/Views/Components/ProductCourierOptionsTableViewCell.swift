//
//  ProductCourierOptionsTableViewCell.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

class ProductCourierOptionsTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var courierPrice: UILabel!
    @IBOutlet weak var destination: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell() {
        
        let courierPriceText = NSMutableAttributedString()
            .normal("Ongkos kirim mulai dari ")
            .bold("Rp21.000")
        self.courierPrice.attributedText = courierPriceText
        
        
        let destinationText = NSMutableAttributedString()
            .normal("Ke ")
            .bold("Jakarta Selatan")
        self.destination.attributedText = destinationText
        
    }
    
}
