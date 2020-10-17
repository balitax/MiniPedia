//
//  CartItemsListOfMerchantsTableViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 15/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol CartItemsListOfMerchantsDelegate: class {
    func didRemoveCart(rows: Int)
    func didUpdateQuantity(rows: Int, qty: Int)
}

class CartItemsListOfMerchantsTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var btnCheckListItemCart: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productStock: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var btnMoveToWhishlist: UIButton!
    
    @IBOutlet weak var btnDeleteItem: UIButton!
    @IBOutlet weak var btnAddQuantityItem: UIButton!
    
    @IBOutlet weak var textfieldQuantityItem: UITextField!
    @IBOutlet weak var btnRemoveQuantityItem: UIButton!
    
    @IBOutlet weak var bottomLine: UIView!
    
    var cart: ProductStorage! {
        didSet {
            self.configureCell()
        }
    }
    
    var rows: Int = 0
    
    private var disposeBag = DisposeBag()
    private var isItemSelected = false
    weak var delegate: CartItemsListOfMerchantsDelegate?
    private var quantity: Int = 1 {
        didSet {
            if quantity == cart.stock  {
                self.btnAddQuantityItem.disabledButton()
                self.btnRemoveQuantityItem.enableBlueButton()
            } else if quantity <= 1 {
                self.btnRemoveQuantityItem.disabledButton()
                self.btnAddQuantityItem.enableBlueButton()
            } else {
                self.btnAddQuantityItem.enableBlueButton()
                self.btnRemoveQuantityItem.enableBlueButton()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bindRx()
    }
    
    private func bindRx() {
        
        self.btnCheckListItemCart.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.isItemSelected.toggle()
                self.btnCheckListItemCart.isCheckboxTapped(self.isItemSelected)
            }).disposed(by: disposeBag)
        
        self.btnAddQuantityItem.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.quantity += 1
                self.textfieldQuantityItem.text = "\(self.quantity)"
                
                self.getQuantityText()
                
            }).disposed(by: disposeBag)
        
        self.btnRemoveQuantityItem.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                if self.quantity > 1 {
                    self.quantity -= 1
                    self.textfieldQuantityItem.text = "\(self.quantity)"
                }
                self.getQuantityText()
                
            }).disposed(by: disposeBag)
        
        self.btnDeleteItem.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.delegate?.didRemoveCart(rows: self.rows)
            }).disposed(by: disposeBag)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func getQuantityText() {
        self.textfieldQuantityItem.rx
            .text
            .orEmpty
            .compactMap { $0 }
            .map { Int($0) }
            .compactMap { $0 }
            .subscribe(onNext: { [unowned self] qty in
                self.delegate?.didUpdateQuantity(rows: rows, qty: qty)
            }).disposed(by: disposeBag)
    }
    
}

extension CartItemsListOfMerchantsTableViewCell {
    
    private func configureCell() {
        self.productName.text = cart.name
        self.productPrice.text = cart.price
        if let imgProduct = cart.imageURI, let imgURL = URL(string: imgProduct) {
            self.productImage.kf.setImage(with: imgURL)
        }
        self.productStock.attributedText = cart.getStock
        self.textfieldQuantityItem.text = "\(cart.quantity)"
        self.quantity = cart.quantity
        
    }
    
}
