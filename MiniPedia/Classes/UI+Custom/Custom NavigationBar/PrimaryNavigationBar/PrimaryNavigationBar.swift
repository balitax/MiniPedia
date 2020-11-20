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
    @IBOutlet private weak var cartButton: ACBadgeButton!
    @IBOutlet private weak var notificationButton: ACBadgeButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let disposeBag = DisposeBag()
    public let cartButtonObservable = PublishSubject<Void>()
    public let notifButtonObservable = PublishSubject<Void>()
    public let searchBarButtonObservable = PublishSubject<Void>()
    
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
       
        Observable.collection(from: ShoppingCart.shared.products)
            .asObservable()
            .subscribe(onNext: { [unowned self] badge in
                if (badge.count != 0) {
                    Delay.wait(delay: 1) {
                        self.cartButton.badgeCount = badge.count
                    }
                } else {
                    Delay.wait(delay: 1) {
                        self.cartButton.badgeCount = ShoppingCart.shared.products.count
                    }
                }
            })
            .disposed(by: disposeBag)
        
        notificationButton.badgeCount = 8
        
        cartButton.rx
            .tap
            .bind {
                self.cartButtonObservable.onNext(())
            }.disposed(by: disposeBag)
        
        notificationButton.rx
            .tap
            .bind {
                self.notifButtonObservable.onNext(())
            }.disposed(by: disposeBag)
        
        searchBar.delegate = self
        
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
        self.view.alpha = offset
        
        if offset >= 1.0 {
            self.navigationView.addShadow(offset: CGSize(width: 0, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor.clear, radius: 4, opacity: 0.8)
        } else {
            self.navigationView.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.clear, borderColor: UIColor.clear, radius: 0, opacity: 0.0)
        }
        
        _ = [cartButton, notificationButton].map {
            $0?.tintColor = UIColor(red: 1 - (offset / 2), green: 1 - (offset / 2), blue: 1 - (offset / 2), alpha: 1)
        }
    }
    
    
}

extension PrimaryNavigationBar: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.endEditing(true)
        self.searchBarButtonObservable.onNext(())
        return false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("SIKAT")
    }
    
}
