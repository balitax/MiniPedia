//
//  ProductDetailView+SkeletonView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 14/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import SkeletonView

extension ProductDetailView: SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return ProductSummaryTableViewCell.reuseIdentifier
        case 1:
            return ProductCourierOptionsTableViewCell.reuseIdentifier
        case 2:
            return ProductInformationTableViewCell.reuseIdentifier
        case 3:
            return DescriptionProductTableViewCell.reuseIdentifier
        default:
            return ProductSummaryTableViewCell.reuseIdentifier
        }
    }
    
}
