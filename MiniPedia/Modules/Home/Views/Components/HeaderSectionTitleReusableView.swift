//
//  HeaderSectionTitleReusableView.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 20/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

class HeaderSectionTitleReusableView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

extension HeaderSectionTitleReusableView: Reusable {}
