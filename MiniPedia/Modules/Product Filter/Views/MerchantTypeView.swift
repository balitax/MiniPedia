//
//  MerchantTypeView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 24/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

protocol MerchantTypeViewDelegate: class {
    func didSelectedMerchantType(_ type: [ShopTypeModel])
}

class MerchantTypeView: UIViewController {
    
    // MARK: - UI Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    // MARK: - VARIABLES
    var selectedType = [ShopTypeModel]() {
        didSet {
            self.selectedDefault()
        }
    }
    
    weak var delegate: MerchantTypeViewDelegate?
    private var type = ShopTypeModel.mock()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Merchant Type"
        
        let dismissBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "dismissBtn"), style: .plain, target: self, action: #selector(self.didDismiss(_:)))
        let resetBarButton = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(self.didResetFilter(_:)))
        
        self.navigationItem.leftBarButtonItem = dismissBarButton
        self.navigationItem.rightBarButtonItem = resetBarButton
        componentTableView()
        
        btnApplyFilter
            .rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.didApplyFilterShopType()
            }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.selectedType.append(self.type[indexPath.row])
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .subscribe(onNext: { [unowned self] indexPath in
                
                if let index = self.selectedType.firstIndex(of: type[indexPath.row]) {
                    self.selectedType.remove(at: index)
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    private func componentTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.registerReusableCell(ShopTypeListTableViewCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
        self.tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
    }
    
    @objc func didDismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didResetFilter(_ sender: UIBarButtonItem) {
        self.selectedType.removeAll()
        self.tableView.reloadData()
    }
    
    func didApplyFilterShopType() {
        self.delegate?.didSelectedMerchantType(self.selectedType)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func selectedDefault() {
        guard self.selectedType.count != 0 else { return }
        Delay.wait(delay: 0.5) {
            for (row, _) in self.selectedType.enumerated() {
                self.tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .none)
            }
        }
    }
    
}


extension MerchantTypeView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShopTypeListTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.lblShopType.text = type[indexPath.row].typeName
        cell.selectionStyle = .none
        return cell
    }
}
