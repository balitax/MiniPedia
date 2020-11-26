//
//  ProductDetailView.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import SkeletonView

class ProductDetailView: UIViewController {
    
    deinit {
        print("##\(self)")
    }
    
    init() {
        super.init(nibName: "ProductDetailView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: SecondaryNavigationBar!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint! {
        didSet {
            if let height = self.navigationController?.navigationBar.frame.height {
                self.navigationBarHeight.constant = height + 44
            }
        }
    }
    @IBOutlet weak var btnAddKeranjang: UIButton!
    @IBOutlet weak var btnOpenToko: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: ProductDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        bindRx()
    }
    
    private func bindRx() {
        
        viewModel.bindProduct()
        
        viewModel
            .state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in
                switch state {
                case .finish:
                    self.onDataReloaded()
                default:
                    self.view.showAnimatedSkeleton()
                }
            }).disposed(by: disposeBag)
        
        viewModel.products
            .asObserver()
            .subscribe(onNext: { [unowned self] product in
                self.navigationBar.title = product?.name ?? ""
            }).disposed(by: disposeBag)
        
        viewModel.cartState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in
                switch state {
                case .done:
                    self.showAlert("Produk telah ditambahkan")
                case .error:
                    self.showAlert("Terjadi kesalahan!", type: .error)
                case .update:
                    self.showAlert("Jumlah produk di perbarui", type: .success)
                default:
                    return
                }
            }).disposed(by: disposeBag)
        
        btnAddKeranjang.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.saveCart()
            }).disposed(by: disposeBag)
        
        btnOpenToko.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.openTokopedia()
            }).disposed(by: disposeBag)
        
        
        navigationBar.leftButtonObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] pip in
                self.viewModel.backButtonDidTap.onNext(())
            }).disposed(by: disposeBag)
        
        navigationBar.cartButtonObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] pip in
                self.viewModel.cartButtonDidTap.onNext(())
            }).disposed(by: disposeBag)
        
        navigationBar.shareButtonObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] pip in
                self.viewModel.shareProduct()
            }).disposed(by: disposeBag)
        
        
    }
    
    private func onDataReloaded() {
        self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        self.tableView.performBatchUpdates {
            self.tableView.layoutIfNeeded()
        } completion: { _ in
            
        }
        
        self.tableView.rx
            .contentOffset
            .subscribe { [unowned self] in
                let getY = $0.element?.y ?? 0
                let offset = CGFloat(round(10*getY / 280)/10)
                self.navigationBar.alpaOffset(offset)
            }.disposed(by: self.disposeBag)
        
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
    }
    
}

extension ProductDetailView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: ProductSummaryTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.viewModel = viewModel
            cell.delegate = self
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

extension ProductDetailView: DescriptionProductDelegate, ProductSummaryDelegate {
    
    func didAddWhishlist() {
        viewModel.saveWhishlist()
    }
    
    func didReadmoreDescription(_ readmore: Bool) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}
