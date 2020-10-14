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
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationBg: UIView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var btnAddKeranjang: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: ProductDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func bindRx() {
        
        self.tableView.rx
            .contentOffset
            .subscribe {
                let getY = $0.element?.y ?? 0
                let offset = CGFloat(round(10*getY / 280)/10)
                self.navigationAnimated(offset: offset, enable: offset >= 1.0)
            }.disposed(by: disposeBag)
        
        DispatchQueue.main.async {
            self.navTitle.text = self.viewModel.product?.name
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
        
        Observable.changeset(from: ShoppingCart.shared.products)
            .subscribe(onNext: { [unowned self] _, changes in
                print("PERUBAHAN ", changes)
            }).disposed(by: disposeBag)
        
        Observable.collection(from: ShoppingCart.shared.products)
            .map { results in "carts: \(results.count)" }
            .subscribe { event in
                print("EVENT ", event.element)
            }.disposed(by: disposeBag)
        
        ShoppingCart.shared
            .shoppingState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { state in
                switch state {
                case .done:
                    print("DONE SAVED")
                case .error:
                    print("ERROR SAVED")
                default:
                    return
                }
            }).disposed(by: disposeBag)
        

        btnAddKeranjang.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                ShoppingCart.shared.addToCart(viewModel.product)
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
    
    private func navigationAnimated(offset: CGFloat, enable: Bool) {
        self.navigationBg.alpha = offset
        self.navTitle.alpha = offset
        if enable {
            self.navTitle.alpha = 1
            self.navigationBg.addShadow(offset: CGSize(width: 0, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor(hexString: "#ededed"), radius: 2, opacity: 0.8)
        } else {
            self.navTitle.alpha = 0
            self.navigationBg.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.clear, borderColor: UIColor.clear, radius: 0, opacity: 0.0)
        }
    }
    
    
}

extension ProductDetailView: DescriptionProductDelegate {
    
    func didReadmoreDescription(_ readmore: Bool) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}
