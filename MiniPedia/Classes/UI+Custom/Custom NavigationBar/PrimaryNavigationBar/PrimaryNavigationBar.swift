//
//  PrimaryNavigationBar.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 14/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

final class PrimaryNavigationBar: UIView {
    
    private static let NIB_NAME = "PrimaryNavigationBar"
    
    @IBOutlet private var view: UIView!
    @IBOutlet private var navigationView: UIView!
    @IBOutlet private var primaryContainerView: UIView!
    @IBOutlet private var secondaryContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cartButton: ACBadgeButton!
    
    private let disposeBag = DisposeBag()
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
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
            .map { results in "\(results.count)" }
            .subscribe { badge in
                self.cartButton.badgeValue = badge
            }
            .disposed(by: disposeBag)
        
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
