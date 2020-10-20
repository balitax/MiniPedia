//
//  PrimaryNavigationBar.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 14/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift
import RxRealm
import RealmSwift
import RxCocoa

final class PrimaryNavigationBar: UIView {
    
    private static let NIB_NAME = "PrimaryNavigationBar"
    
    @IBOutlet private var view: UIView!
    @IBOutlet private var navigationView: UIView!
    @IBOutlet private var primaryContainerView: UIView!
    @IBOutlet private var secondaryContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cartButton: ACBadgeButton!
    @IBOutlet private weak var backButton: UIButton!
    
    private let disposeBag = DisposeBag()
    public let cartButtonObservable = PublishSubject<Void>()
    public let backButtonObservable = PublishSubject<Void>()
    
    var title: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.titleLabel.text = self.title.isEmpty ? "" : self.title
            }
        }
    }
    var enableRightButton: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.cartButton.isHidden = !self.enableRightButton
            }
        }
    }
    
    var enableLeftButton: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.backButton.isHidden = !self.enableLeftButton
            }
        }
    }
    
    override func awakeFromNib() {
        initWithNib()
        setupUI()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(PrimaryNavigationBar.NIB_NAME, owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        setupLayout()
    }
    
    private func setupUI() {
        self.navigationView.addShadow(offset: CGSize(width: 0, height: 3), color: UIColor(hexString: "#ededed"), borderColor: UIColor(hexString: "#ededed"), radius: 4, opacity: 0.8)
        
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
        
        backButton.rx
            .tap
            .bind {
                self.backButtonObservable.onNext(())
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
    
    
}
