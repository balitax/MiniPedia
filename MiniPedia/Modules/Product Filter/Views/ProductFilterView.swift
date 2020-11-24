//
//  ProductFilterView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 24/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

protocol ProductFilterDelegate: class {
    func didApplyFilter(_ filter: ProductFilterRequest?)
}

class ProductFilterView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    var viewModel: ProductFilterViewModel!
    weak var delegate: ProductFilterDelegate?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Filter"
        let dismissBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "dismissBtn"), style: .plain, target: self, action: #selector(self.didDismissFilterView(_:)))
        let resetBarButton = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(self.didResetFilterView(_:)))
        
        self.navigationItem.leftBarButtonItem = dismissBarButton
        self.navigationItem.rightBarButtonItem = resetBarButton
        
        btnApplyFilter
            .rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.delegate?.didApplyFilter(self.viewModel.request)
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        componentTableView()
    }
    
    private func componentTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.registerReusableCell(PriceRangeTableViewCell.self)
        self.tableView.registerReusableCell(ShopTypeTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    @objc func didDismissFilterView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didResetFilterView(_ sender: UIBarButtonItem) {
        viewModel.request.shopType.removeAll()
        self.viewModel.request.reset()
        self.tableView.reloadData()
    }
    
}

extension ProductFilterView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: PriceRangeTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.delegate = self
            
            cell.lowerPrice = self.viewModel.request.lowerPrice
            cell.upperPrice = self.viewModel.request.upperPrice
            cell.isWholeStore = self.viewModel.request.isWholeStore
            
            cell.selectionStyle = .none
            return cell
        } else {
            let cell: ShopTypeTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            
            cell.delegate = self
            cell.shopType = viewModel.request.shopType
            cell.componentCollectionView()
            cell.collectionView.reloadData()
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
}


extension ProductFilterView: PriceRangeTableViewDelegate, ShopTypeTableViewDelegate, MerchantTypeViewDelegate {
    
    func didSelectedMerchantType(_ type: [ShopTypeModel]) {
        viewModel.request.shopType = type
        viewModel.request.isOfficial = ShopTypeModel.isMerchantOfficial(type)
        viewModel.request.isGoldSeller = ShopTypeModel.isMerchantGold(type)
        tableView.reloadData()
    }
    
    func priceRange(_ lowerPrice: Double, upperPrice: Double) {
        viewModel.request.lowerPrice = lowerPrice
        viewModel.request.upperPrice = upperPrice
    }
    
    func isWholeStore(_ isWholeStore: Bool) {
        viewModel.request.isWholeStore = isWholeStore
    }
    
    func didSelectShopType() {
        let merchant = MerchantTypeBinding(delegate: self, selected: self.viewModel.request.shopType)
        viewModel.merchantTypeDidTap.onNext(merchant)
    }
    
    func didDeleteMerchantTypeSelected(_ shopType: [ShopTypeModel]) {
        viewModel.request.shopType = shopType
        viewModel.request.isOfficial = ShopTypeModel.isMerchantOfficial(shopType)
        viewModel.request.isGoldSeller = ShopTypeModel.isMerchantGold(shopType)
        tableView.reloadData()
    }
    
    
}
