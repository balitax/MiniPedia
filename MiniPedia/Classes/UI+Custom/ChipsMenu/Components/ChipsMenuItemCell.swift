//
//  ChipsMenuItemCell.swift
//  tenantapp
//
//  Created by Agus Cahyono on 21/10/20.
//  Copyright © 2020 RoomMe. All rights reserved.
//

import UIKit

class ChipsMenuItemCell: UICollectionViewCell, Reusable {
    
    @IBOutlet var tagLabel: UILabel!
    @IBOutlet var tagContainer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tagContainer.cornerRadius = 14
        self.tagContainer.clipsToBounds = true
        self.setUnselected()
    }
    
    func setSelected() {
        self.tagContainer.layer.backgroundColor = Colors.greenColor.withAlphaComponent(0.1).cgColor
        self.tagLabel.textColor = Colors.greenColor
        self.tagContainer.layer.borderWidth = 1
        self.tagContainer.layer.borderColor = Colors.greenColor.cgColor
    }
    
    func setUnselected() {
        self.tagContainer.layer.backgroundColor = UIColor.white.cgColor
        self.tagLabel.textColor = UIColor.darkGray
        self.tagContainer.layer.borderWidth = 1
        self.tagContainer.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected ? self.setSelected() : self.setUnselected()
        }
    }
    
    func configure(_ name: String?, maxWidth: CGFloat) {
        self.tagLabel.text = name
        self.tagLabel.preferredMaxLayoutWidth =  maxWidth
    }
    
}
