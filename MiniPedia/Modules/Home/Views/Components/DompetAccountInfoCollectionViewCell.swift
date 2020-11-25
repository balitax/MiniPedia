//
//  DompetAccountInfoCollectionViewCell.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 20/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

class DompetAccountInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.showAnimatedGradientSkeleton()
        
        self.containerView.cornerRadius = 8
        self.containerView.clipsToBounds = true
        self.containerView.addShadow(offset: CGSize(width: 1, height: 4), color: UIColor(hexString: "#ededed"), borderColor: UIColor(hexString: "#ededed"), radius: 6, opacity: 0.8)
    }
    
    func configureCell(_ bind: Bool) {
        Delay.wait(delay: 0) {
            self.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        }
    }
    
}

extension DompetAccountInfoCollectionViewCell: Reusable {}
