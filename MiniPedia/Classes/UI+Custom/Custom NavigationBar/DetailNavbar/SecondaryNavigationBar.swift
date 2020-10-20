//
//  SecondaryNavigationBar.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 14/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

final class SecondaryNavigationBar: UIView {
    
    private static let NIB_NAME = "SecondaryNavigationBar"
    
    @IBOutlet private var view: UIView!
    @IBOutlet private var navigationView: UIView!
    @IBOutlet private var primaryContainerView: UIView!
    @IBOutlet private var secondaryContainerView: UIView!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var cartButton: ACBadgeButton!
    @IBOutlet private weak var moreButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    public let leftButtonObservable = PublishSubject<Void>()
    public let cartButtonObservable = PublishSubject<Void>()
    public let shareButtonObservable = PublishSubject<Void>()
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: -- Offset Follow ScrollView
    var setOffset: CGFloat = 1 {
        didSet {
            
            self.secondaryContainerView.alpha = setOffset
            
            if setOffset >= 1.0 {
                self.titleLabel.alpha = 1
                self.navigationView.addShadow(offset: CGSize(width: 0, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor(hexString: "#ededed"), radius: 2, opacity: 0.8)
            } else if setOffset >= 0.5 && setOffset <= 1.0 {
                self.buttonTintColor(setOffset)
            } else {
                self.buttonTintColor(0)
                self.titleLabel.alpha = 0
                self.navigationView.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.clear, borderColor: UIColor.clear, radius: 0, opacity: 0.0)
            }
            
        }
    }
    
    
    var isLeftButtonHidden: Bool {
        set {
            leftButton.isHidden = newValue
        }
        get {
            return leftButton.isHidden
        }
    }
    
    var enableRightButtonItems: Bool {
        set {
            _ = [shareButton, cartButton, moreButton].map { $0?.isHidden = newValue }
        }
        get {
            return true
        }
    }
    
    override func awakeFromNib() {
        initWithNib()
        setupUI()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(SecondaryNavigationBar.NIB_NAME, owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        setupLayout()
    }
    
    private func setupUI() {
        
        Observable.collection(from: ShoppingCart.shared.products)
            .asObservable()
            .subscribe(onNext: { [unowned self] badge in
                if (badge.count != 0) {
                    self.cartButton.badgeValue = "\(badge.count)"
                } else {
                    self.cartButton.badgeValue = ""
                }
            })
            .disposed(by: disposeBag)
        
        cartButton.rx
            .tap
            .bind {
                self.cartButtonObservable.onNext(())
            }.disposed(by: disposeBag)
        
        leftButton.rx
            .tap
            .bind {
                self.leftButtonObservable.onNext(())
            }.disposed(by: disposeBag)
        
        shareButton.rx
            .tap
            .bind {
                self.shareButtonObservable.onNext(())
            }.disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
    
    private func buttonTintColor(_ offset: CGFloat) {
        _ = [leftButton, shareButton, cartButton, moreButton].map {
            $0?.tintColor = UIColor(red: 1 - (offset / 2), green: 1 - (offset / 2), blue: 1 - (offset / 2), alpha: 1)
        }
    }
    
}
