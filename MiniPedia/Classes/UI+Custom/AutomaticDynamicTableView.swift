//
//  AutomaticDynamicTableView.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

class AutomaticDynamicTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
