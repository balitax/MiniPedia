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
    
    let disposeBag = DisposeBag()
    var viewModel: ProductDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    
    private func setupTableView() {
        self.tableView.registerReusableCell(ProductSummaryTableViewCell.self)
        self.tableView.registerReusableCell(ProductCourierOptionsTableViewCell.self)
        self.tableView.registerReusableCell(ProductInformationTableViewCell.self)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .systemGroupedBackground
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.tableView.reloadData()
    }

}

extension ProductDetailView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 0 : 1
    }

//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        section == 0 ? 0 : 1
//    }
    
}
