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
    
    private var disposeBag = DisposeBag()
    
    var viewModel: HomeViewViewModel! {
        didSet {
            viewModel.loaded.asObserver()
                .subscribe(onNext: { [unowned self] loaded in
                    loaded ? self.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5)) : self.showAnimatedSkeleton()
                }).disposed(by: self.disposeBag)
        }
    }
    
    private var urlImageBanner = [
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/18/dce6af24-8978-48fc-a379-50cf9136c1ff.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/18/61f648ff-9913-4109-811a-43521a40926b.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/19/dde94860-7ac9-46b7-baeb-2c659b66ce86.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/19/0ccc364c-77ea-4da3-b14c-11f2cb55cb08.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/18/dce6af24-8978-48fc-a379-50cf9136c1ff.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/18/61f648ff-9913-4109-811a-43521a40926b.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/19/dde94860-7ac9-46b7-baeb-2c659b66ce86.jpg",
        "https://ecs7-p.tokopedia.net/img/cache/800/VxWOnu/2020/10/19/0ccc364c-77ea-4da3-b14c-11f2cb55cb08.jpg"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.showAnimatedSkeleton()
        bannerSetup()
    }
    
    private func bannerSetup() {
        bannerSlide.delegate = self
        bannerSlide.placeholderImage = #imageLiteral(resourceName: "Apple")
        bannerSlide.setUrlsGroup(urlImageBanner)
        bannerSlide.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 300)
        bannerSlide.itemSpacing = 0
        bannerSlide.timeInterval = 4
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
