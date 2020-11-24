//
//  PriceRangeTableViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 08/09/20.
//

import UIKit

protocol PriceRangeTableViewDelegate {
    func priceRange(_ lowerPrice: Double, upperPrice: Double)
    func isWholeStore(_ isWholeStore: Bool)
}

extension PriceRangeTableViewDelegate {
    
    func priceRange(_ lowerPrice: Double, upperPrice: Double) {
        priceRange(lowerPrice, upperPrice: upperPrice)
    }
    
    func isWholeStore(_ isWholeStore: Bool = false) { }
    
    
}


class PriceRangeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceRange: RubberRangePicker!
    @IBOutlet weak var minPrice: UILabel!
    @IBOutlet weak var maxPrice: UILabel!
    @IBOutlet weak var isWholeSaleSwitch: UISwitch!
    
    var delegate: PriceRangeTableViewDelegate?
    var isWholeStore = false {
        didSet {
            Delay.wait(delay: 0.1) {
                self.isWholeSaleSwitch.setOn(self.isWholeStore, animated: true)
            }
        }
    }
    
    var lowerPrice: Double = 0 {
        didSet {
            Delay.wait(delay: 0.3) {
                self.priceRange.lowerValue = self.lowerPrice
                self.minPrice.text = self.priceRange.lowerValue.convertIntoRupiah()
            }
        }
    }
    var upperPrice: Double = 0 {
        didSet {
            Delay.wait(delay: 0.3) {
                print("UPP ", self.upperPrice)
                self.priceRange.upperValue = self.upperPrice
                self.maxPrice.text = self.priceRange.upperValue.convertIntoRupiah()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        priceRange.elasticBehavior = .linear
        priceRange.damping = 2
        priceRange.thumbSize = 20.0
        priceRange.tintColor = UIColor(hexString: "#008C14")
        priceRange.elasticity = 1
        priceRange.minimumValue = 100
        priceRange.maximumValue = 8000000
        priceRange.lowerValue = 100
        priceRange.upperValue = 1000000
        priceRange.addTarget(self, action: #selector(self.updatePriceRange(_:)), for: .valueChanged)
        
        minPrice.text = priceRange.lowerValue.convertIntoRupiah()
        maxPrice.text = priceRange.upperValue.convertIntoRupiah()
        
        self.isWholeSaleSwitch.addTarget(self, action: #selector(self.updateWholeStore(_:)), for: .valueChanged)
        
    }
    
    @objc func updatePriceRange(_ sender: RubberRangePicker) {
        minPrice.text = priceRange.lowerValue.convertIntoRupiah()
        maxPrice.text = priceRange.upperValue.convertIntoRupiah()
        self.delegate?.priceRange(priceRange.lowerValue, upperPrice: priceRange.upperValue)
    }
    
    @objc func updateWholeStore(_ sender: UISwitch) {
        self.isWholeStore = sender.isOn
        self.delegate?.isWholeStore(isWholeStore)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension PriceRangeTableViewCell: Reusable { }
