//
//  CartView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 15/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import RealmSwift
import RxRealm
import SkeletonView

class CartView: UIViewController {
    
    deinit {
        print("##\(self)")
    }
    
    init() {
        super.init(nibName: "CartView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var navigationBar: SecondaryNavigationBar!
    @IBOutlet weak var tableView: AutomaticDynamicTableView!
    @IBOutlet weak var selectedCart: UILabel!
    @IBOutlet weak var btnDeleteAll: UIButton!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var heightAllCartSelectContainer: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    var viewModel: CartViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindRx()
    }
    
    private func bindRx() {
        
        viewModel.getCartData()
        enableBtnDeleteAll(false)
        
        viewModel.state
            .asObserver()
            .subscribe(onNext: { [unowned self] state in
                if state == .finish {
                    self.reloadTableView()
                    self.hideLoading()
                } else {
                    self.showLoading()
                }
            }).disposed(by: disposeBag)
        
        Observable.changeset(from: viewModel.cart)
            .subscribe(onNext: { [unowned self] data, changes in
                if let changes = changes {
                    self.tableView.applyChangeset(changes)
                } else {
                    self.tableView.reloadData()
                }
                if data.count != 0 {
                    self.heightAllCartSelectContainer.constant = 36
                } else {
                    self.heightAllCartSelectContainer.constant = 0
                }
                self.viewModel.countCartSelectable()
            })
            .disposed(by: disposeBag)
        
        viewModel.cartSelectObservable
            .bind(to: btnSelectAll.rx.isCheckBoxSelected)
            .disposed(by: disposeBag)
        
        viewModel.cartCountSelectObservable
            .bind(to: self.selectedCart.rx.text)
            .disposed(by: disposeBag)
        
        btnSelectAll.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.enableBtnDeleteAll(true)
                self.viewModel.didSelectAllCart()
            }).disposed(by: disposeBag)
        
        viewModel.isAllCartSelected
            .asObservable()
            .subscribe(onNext: { [unowned self] selected in
                self.btnSelectAll.isCheckboxTapped(selected)
                selected == false ? self.enableBtnDeleteAll(false) : self.enableBtnDeleteAll(true)
            }).disposed(by: disposeBag)
        
        btnDeleteAll.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.deleteAllCartObservable.onNext(())
            }).disposed(by: disposeBag)
        
        navigationBar.title = "Cart"
        navigationBar.fontFize(20)
        navigationBar.isLeftButtonHidden = true
        navigationBar.enableRightButtonItems = false
        navigationBar.isEnableShadow = false
        navigationBar.alpaOffset(1)
        
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    
    private func enableBtnDeleteAll(_ enable: Bool) {
        if enable {
            self.btnDeleteAll.setTitleColor(Colors.greenColor, for: .normal)
            self.btnDeleteAll.isEnabled = true
        } else {
            self.btnDeleteAll.setTitleColor(UIColor.lightGray, for: .normal)
            self.btnDeleteAll.isEnabled = false
        }
    }
    
    private func setupTableView() {
        self.tableView.registerReusableCell(CartItemByMerchantsCell.self)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .systemGroupedBackground
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.separatorStyle = .none
        self.tableView.keyboardDismissMode = .onDrag
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.tableView.tableFooterView = UIView(frame: frame)
        
        self.view.showAnimatedGradientSkeleton()
    }
    
    
}

extension CartView: CartItemByMerchantsDelegate {
    
    func didAddNoteItemCart(section: Int, rows: Int, note: String) {
        viewModel.addNoteProductToCartItem(section: section, rows: rows, note: note)
    }
    
    func didUpdateQuantity(section: Int, rows: Int, qty: Int) {
        viewModel.updateProductQuantity(section: section, rows: rows, qty: qty)
    }
    
    func didRemoveCartItem(section: Int, rows: Int) {
        viewModel.deleteCartByProductMerchant(section: section, rows: rows)
    }
    
    func didSelectProductItem(section: Int, rows: Int, isSelected: Bool) {
        viewModel.didSelectProductItem(section: section, rows: rows, isSelected: isSelected)
    }
    
    func didSelectProductAllMerchant(section: Int, selected: Bool) {
        viewModel.didSelectAllProductMerchant(section: section, selected: selected)
    }
    
    func didMoveToWhishlist(section: Int, rows: Int) {
        viewModel.didMoveProductCartToWhishlist(section: section, rows: rows)
    }
    
    func didSelectProductForDetail(section: Int, rows: Int) {
        viewModel.getDetailProduct(section: section, rows: rows)
    }
    
}

extension CartView: UITableViewDataSource, UITableViewDelegate, EmptyStateViewDelegate {
    
    func didTapState() {
        // belanja sekarang
        viewModel.buyNowObservable.onNext(())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.cart.count == 0 {
            tableView.setEmptyView(stateType: .cart, delegate: self)
        }
        else {
            tableView.restore()
        }
        return viewModel.cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartItemByMerchantsCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.merchant = viewModel.cart[indexPath.row]
        cell.section = indexPath.row
        cell.delegate = self
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 0 : 1
    }
    
}

extension CartView: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        CartItemByMerchantsCell.reuseIdentifier
    }
    
}
