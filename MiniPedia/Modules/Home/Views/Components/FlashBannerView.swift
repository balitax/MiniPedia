//
//  FlashBannerView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 19/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

class FlashBannerView: UICollectionReusableView {
    
    @IBOutlet weak var bannerSlide: ZCycleView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerSetup()
    }
    
    private func bannerSetup() {
        bannerSlide.delegate = self
        bannerSlide.backgroundColor = .lightGray
        bannerSlide.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 300)
        bannerSlide.itemSpacing = 0
        bannerSlide.timeInterval = 4
    }
    
    func bindFakeBanner(_ data: [String]) {
        bannerSlide.setUrlsGroup(data)
    }
    
}

extension FlashBannerView: Reusable { }

extension FlashBannerView: ZCycleViewProtocol {
    
    func cycleViewConfigureDefaultCellImage(_ cycleView: ZCycleView, imageView: UIImageView, image: UIImage?, index: Int) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = true
    }
    
    func cycleViewConfigureDefaultCellImageUrl(_ cycleView: ZCycleView, imageView: UIImageView, imageUrl: String?, index: Int) {
        imageView.setImageFromNetwork(url: imageUrl ?? "")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func cycleViewConfigureDefaultCellText(_ cycleView: ZCycleView, titleLabel: UILabel, index: Int) {
        titleLabel.isHidden = true
    }
    
    func cycleViewConfigurePageControl(_ cycleView: ZCycleView, pageControl: ZPageControl) {
        pageControl.alignment = .left
        pageControl.isHidden = false
    }
    
    func cycleViewDidSelectedIndex(_ cycleView: ZCycleView, index: Int) {
        
    }
    
}
