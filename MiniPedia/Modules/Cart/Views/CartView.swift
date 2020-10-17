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
    
    @IBOutlet weak var navigationBar: PrimaryNavigationBar! {
        didSet {
            navigationBar.title = "Keranjang"
            navigationBar.enableRightButton = false
            navigationBar.enableLeftButton = true
        }
    }
    @IBOutlet weak var tableView: AutomaticDynamicTableView!
    @IBOutlet weak var selectedCart: UILabel!
    @IBOutlet weak var btnDeleteAll: UIButton!
    @IBOutlet weak var btnSelectAll: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: CartViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindRx()
    }
    
    private func bindRx() {
        
        navigationBar.backButtonObservable
            .asObserver()
            .subscribe(onNext: { [unowned self] _ in
                viewModel.backButtonDidTap.onNext(())
            }).disposed(by: disposeBag)
        
        viewModel.getCartData()
        
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
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
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
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.tableView.tableFooterView = UIView(frame: frame)
        
        self.view.showAnimatedSkeleton()
    }
    
    
}

extension CartView: CartItemByMerchantsDelegate {
    
    func didUpdateQuantity(section: Int, rows: Int, qty: Int) {
        viewModel.updateProductQuantity(section: section, rows: rows, qty: qty)
    }
    
    func didRemoveCartItem(section: Int, rows: Int) {
        viewModel.deleteCartByProductMerchant(section: section, rows: rows)
    }
    
}

extension CartView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartItemByMerchantsCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.merchant = viewModel.cart[indexPath.row]
        cell.section = indexPath.row
        cell.delegate = self
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

extension UITableView {
    func applyChangeset(_ changes: RealmChangeset) {
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .fade)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .fade)
        reloadRows(at: changes.updated.map { IndexPath(row: $0, section: 0) }, with: .fade)
        endUpdates()
    }
}
