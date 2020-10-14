//
//  ProductDetailView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import RealmSwift

class ProductDetailView: UIViewController {
    
    init() {
        super.init(nibName: "ProductDetailView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    @IBOutlet weak var navigationBar: SecondaryNavigationBar!
    @IBOutlet weak var btnAddKeranjang: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: ProductDetailViewModel!
    lazy var alert = ACAlertsView(position: .bottom, direction: .toRight, marginBottom: 150)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindRx()
    }
    
    private func bindRx() {
        
        self.tableView.rx
            .contentOffset
            .subscribe { [unowned self] in
                let getY = $0.element?.y ?? 0
                let offset = CGFloat(round(10*getY / 280)/10)
                self.navigationBar.setOffset = offset
            }.disposed(by: disposeBag)
        
        DispatchQueue.main.async {
            self.navigationBar.title = self.viewModel.product?.name ?? ""
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
        
//        Observable.changeset(from: ShoppingCart.shared.products)
//            .subscribe(onNext: { [unowned self] _, changes in
//                print("PERUBAHAN ", changes)
//            }).disposed(by: disposeBag)
//
//        Observable.collection(from: ShoppingCart.shared.products)
//            .map { results in "carts: \(results.count)" }
//            .subscribe { event in
//                print("EVENT ", event.element)
//            }.disposed(by: disposeBag)
        
        ShoppingCart.shared
            .shoppingState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in
                switch state {
                case .done:
                    self.alert.show("Success! \nThis product has been add to your cart", style: .success)
                case .error:
                    self.alert.show("Error! \nThere is an error while add this product to cart", style: .error)
                default:
                    return
                }
            }).disposed(by: disposeBag)
        

        btnAddKeranjang.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                ShoppingCart.shared.addToCart(viewModel.product)
            }).disposed(by: disposeBag)
        
        navigationBar.leftButtonObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] pip in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
    }
    
    private func setupTableView() {
        self.tableView.registerReusableCell(ProductSummaryTableViewCell.self)
        self.tableView.registerReusableCell(ProductCourierOptionsTableViewCell.self)
        self.tableView.registerReusableCell(ProductInformationTableViewCell.self)
        self.tableView.registerReusableCell(DescriptionProductTableViewCell.self)
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
        
        self.tableView.reloadData()
    }
    
    
}

extension ProductDetailView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: ProductSummaryTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.viewModel = viewModel
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell: ProductCourierOptionsTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.configureCell()
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell: ProductInformationTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell: DescriptionProductTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.configureCell()
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 0 : 1
    }
    
}

extension ProductDetailView: DescriptionProductDelegate {
    
    func didReadmoreDescription(_ readmore: Bool) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}
