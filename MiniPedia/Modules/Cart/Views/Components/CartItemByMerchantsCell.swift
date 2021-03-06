//
//  CartItemByMerchantsCell.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 15/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import SkeletonView
import RxSwift
import RxCocoa

protocol CartItemByMerchantsDelegate: class {
    func didAddNoteItemCart(section: Int, rows: Int, note: String)
    func didRemoveCartItem(section: Int, rows: Int)
    func didUpdateQuantity(section: Int, rows: Int, qty: Int)
    func didSelectProductItem(section: Int, rows: Int, isSelected: Bool)
    func didSelectProductAllMerchant(section: Int, selected: Bool)
    func didMoveToWhishlist(section: Int, rows: Int)
    func didSelectProductForDetail(section: Int, rows: Int)
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
    private var getMerchantLocation: String = ""

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
        self.cartTableView.delegate = self
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
        self.getMerchantLocation = self.merchant?.location ?? ""
    }
    
}

extension CartItemByMerchantsCell: CartItemsListOfMerchantsDelegate {
    
    func didAddNoteItemCart(rows: Int, note: String) {
        self.delegate?.didAddNoteItemCart(section: section, rows: rows, note: note)
    }
    
    func didUpdateQuantity(rows: Int, qty: Int) {
        self.delegate?.didUpdateQuantity(section: section, rows: rows, qty: qty)
    }
    
    func didRemoveCart(rows: Int) {
        self.delegate?.didRemoveCartItem(section: section, rows: rows)
    }
    
    func didSelectProduct(rows: Int, isSelected: Bool) {
        self.delegate?.didSelectProductItem(section: section, rows: rows, isSelected: isSelected)
    }
    
    func didMoveToWhishlist(rows: Int) {
        self.delegate?.didMoveToWhishlist(section: section, rows: rows)
    }
    
}

extension CartItemByMerchantsCell: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectProductForDetail(section: self.section, rows: indexPath.row)
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
