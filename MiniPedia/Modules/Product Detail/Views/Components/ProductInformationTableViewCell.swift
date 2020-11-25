//
//  ProductInformationTableViewCell.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import SkeletonView

class ProductInformationTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var infoTableView: AutomaticDynamicTableView! {
        didSet {
            self.setupTableView()
        }
    }
    
    var mock = InformationProductMock.mock()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.infoTableView.layoutIfNeeded()
    }
    
    private func setupTableView() {
        self.infoTableView.registerReusableCell(ListInformationProductTableViewCell.self)
        self.infoTableView.estimatedRowHeight = 35
        self.infoTableView.rowHeight = UITableView.automaticDimension
        self.infoTableView.tableFooterView = UIView()
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.infoTableView.backgroundColor = .white
        self.infoTableView.separatorStyle = .none
        self.infoTableView.isScrollEnabled = false
        self.infoTableView.reloadData()
    }
    
}

extension ProductInformationTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListInformationProductTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.info = mock[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
}

extension ProductInformationTableViewCell: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ListInformationProductTableViewCell.reuseIdentifier
    }
    
}
