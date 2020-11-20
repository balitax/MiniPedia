//
//  CartItemByMerchantsCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 15/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import SkeletonView
import RxSwift
import RxCocoa

protocol CartItemByMerchantsDelegate: class {
    func didRemoveCartItem(section: Int, rows: Int)
    func didUpdateQuantity(section: Int, rows: Int, qty: Int)
    func didSelectProductItem(section: Int, rows: Int, isSelected: Bool)
    func didSelectProductAllMerchant(section: Int, selected: Bool)
}

class CartItemByMerchantsCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var cartTableView: AutomaticDynamicTableView!
    @IBOutlet weak var btnCheckListMerchant: UIButton!
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantLocation: UILabel!
    
    var merchant: CartStorage? {
        didSet {
            if let selected = self.merchant?.merchantSelected {
                self.isMerchantSelected = selected
            }
            self.cartTableView.reloadData()
            self.bindCell()
        }
    }
    
    var section: Int = 0
    
    private var disposeBag = DisposeBag()
    private var isMerchantSelected = false {
        didSet {
            self.btnCheckListMerchant.isCheckboxTapped(self.isMerchantSelected)
        }
    }
    weak var delegate: CartItemByMerchantsDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTableView()
        bindRx()
    }
    
    private func bindRx() {
        self.btnCheckListMerchant.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.isMerchantSelected.toggle()
                self.delegate?.didSelectProductAllMerchant(
                    section: self.section,
                    selected: self.isMerchantSelected)
            }).disposed(by: disposeBag)
    }
    
    override func layoutIfNeeded() {
        cartTableView.layoutIfNeeded()
    }
    
    private func setupTableView() {
        self.cartTableView.registerReusableCell(CartItemsListOfMerchantsTableViewCell.self)
        self.cartTableView.rowHeight = UITableView.automaticDimension
        self.cartTableView.estimatedRowHeight = UITableView.automaticDimension
        self.cartTableView.dataSource = self
        self.cartTableView.backgroundColor = .systemGroupedBackground
        self.cartTableView.contentInsetAdjustmentBehavior = .never
        self.cartTableView.separatorStyle = .none
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.cartTableView.tableHeaderView = UIView(frame: frame)
        self.cartTableView.tableFooterView = UIView(frame: frame)
        self.cartTableView.reloadData()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindCell() {
        self.merchantName.text = self.merchant?.name
        self.merchantLocation.text = self.merchant?.location
    }
    
}

extension CartItemByMerchantsCell: CartItemsListOfMerchantsDelegate {
    
    func didUpdateQuantity(rows: Int, qty: Int) {
        self.delegate?.didUpdateQuantity(section: section, rows: rows, qty: qty)
    }
    
    func didRemoveCart(rows: Int) {
        self.delegate?.didRemoveCartItem(section: section, rows: rows)
    }
    
    func didSelectProduct(rows: Int, isSelected: Bool) {
        self.delegate?.didSelectProductItem(section: section, rows: rows, isSelected: isSelected)
    }
    
}

extension CartItemByMerchantsCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return merchant?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartItemsListOfMerchantsTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        
        if let cart = merchant?.products {
            cell.cart = cart[indexPath.row]
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.bottomLine.isHidden = true
        } else {
            cell.bottomLine.isHidden = true
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
}

extension CartItemByMerchantsCell: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return CartItemsListOfMerchantsTableViewCell.reuseIdentifier
    }
    
}
