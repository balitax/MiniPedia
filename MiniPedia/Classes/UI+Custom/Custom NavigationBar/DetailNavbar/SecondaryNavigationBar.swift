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
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var cartButton: ACBadgeButton!
    
    private let disposeBag = DisposeBag()
    
    public let leftButtonObservable = PublishSubject<Void>()
    public let cartButtonObservable = PublishSubject<Void>()
    public let shareButtonObservable = PublishSubject<Void>()
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
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
            _ = [shareButton, cartButton].map { $0?.isHidden = newValue }
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
                    self.cartButton.badgeCount = badge.count
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
    
    public func alpaOffset(_ offset: CGFloat) {
        
        self.view.backgroundColor = UIColor(white: 1, alpha: offset)
        
        if offset >= 1.0 {
            self.navigationView.addShadow(offset: CGSize(width: 0, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor.clear, radius: 4, opacity: 0.8)
            self.navigationView.backgroundColor = .white
        }  else {
            self.navigationView.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.clear, borderColor: UIColor.clear, radius: 0, opacity: 0.0)
        }
        
        _ = [leftButton, shareButton, cartButton].map {
            $0?.tintColor = UIColor(red: 1 - (offset / 2), green: 1 - (offset / 2), blue: 1 - (offset / 2), alpha: 1)
        }
        
        titleLabel.textColor = UIColor(red: 1 - (offset / 2), green: 1 - (offset / 2), blue: 1 - (offset / 2), alpha: 1)
    }
    
}
