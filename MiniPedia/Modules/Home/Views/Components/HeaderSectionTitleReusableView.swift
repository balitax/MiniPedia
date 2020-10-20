//
//  HeaderSectionTitleReusableView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 20/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

class HeaderSectionTitleReusableView: UICollectionReusableView {
    
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var btnSeeAll: UIButton!
    
    var viewModel: HomeViewViewModel! {
        didSet {
            configureCell()
        }
    }
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.showAnimatedSkeleton()
    }
    
    private func configureCell() {
        
        viewModel.loaded.asObserver()
            .subscribe(onNext: { [unowned self] loaded in
                loaded ? self.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5)) : self.showAnimatedSkeleton()
            }).disposed(by: self.disposeBag)
        
    }
    
}

extension HeaderSectionTitleReusableView: Reusable {}
