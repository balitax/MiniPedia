//
//  ListInformationProductTableViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

class ListInformationProductTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var titleInfo: UILabel!
    @IBOutlet weak var descriptionInfo: UILabel!
    
    var info: InformationProductMock! {
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
        self.titleInfo.text = info.title
        self.descriptionInfo.text = info.description
        
        if let infoTitle = info.title {
            if infoTitle.contains("Kategori") || infoTitle.contains("Etalase") {
                self.descriptionInfo.textColor = UIColor(hexString: "#03ac0e")
            } else {
                self.descriptionInfo.textColor = .systemGray
            }
        }
        
    }
    
}
