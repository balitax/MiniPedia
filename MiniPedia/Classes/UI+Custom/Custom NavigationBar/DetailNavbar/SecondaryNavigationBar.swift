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
    @IBOutlet private var mainNavigationView: UIView!
    @IBOutlet private var navigationView: UIView!
    @IBOutlet private var primaryContainerView: UIView!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var searchBarLabel: UISearchBar!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var cartButton: ACBadgeButton!
    
    private let disposeBag = DisposeBag()
    
    public let leftButtonObservable = PublishSubject<Void>()
    public let cartButtonObservable = PublishSubject<Void>()
    public let shareButtonObservable = PublishSubject<Void>()
    public let searchProductObservable = PublishSubject<String>()
    
    var title: String = "" {
        didSet {
            searchBarLabel.isHidden = true
            titleLabel.text = title
            titleLabel.isHidden = title.isEmpty
        }
    }
    
    var titleOnSearchBar: String = "" {
        didSet {
            searchBarLabel.isHidden = false
            titleLabel.isHidden = true
            if titleOnSearchBar.isEmpty {
                searchBarLabel.placeholder = "Cari produk disini..."
            } else {
                searchBarLabel.text = titleOnSearchBar
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
            _ = [shareButton, cartButton].map { $0?.isHidden = !newValue }
        }
        get {
            return true
        }
    }
    
    var enableShareButton: Bool {
        set {
            self.shareButton.isHidden = !newValue
        }
        get {
            return true
        }
    }
    
    var isEnableShadow: Bool = true {
        didSet {
            self.mainNavigationView.addShadow(offset: CGSize(width: 0, height: 2), color: isEnableShadow ? UIColor(hexString: "#ededed") : UIColor.clear, borderColor: UIColor.clear, radius: 4, opacity: 0.8)
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
        
        self.mainNavigationView.addShadow(offset: CGSize(width: 0, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor.clear, radius: 4, opacity: 0.8)
        
        Observable.collection(from: ShoppingCart.shared.products)
            .asObservable()
            .subscribe(onNext: { [unowned self] badge in
                if (badge.count != 0) {
                    Delay.wait(delay: 0.5) {
                        self.cartButton.badgeCount = badge.count
                    }
                } else {
                    Delay.wait(delay: 0.5) {
                        self.cartButton.badgeCount = ShoppingCart.shared.products.count
                    }
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
        
        searchBarLabel.delegate = self
        searchBarLabel.rx
            .text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let text = text else { return }
                if !text.isEmpty {
                    self?.searchProductObservable.onNext(text)
                }
            }).disposed(by: disposeBag)
        
        
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
    
    public func setAutoFocus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.searchBarLabel.becomeFirstResponder()
        }
    }
    
    public func fontFize(_ size: CGFloat) {
        self.titleLabel.font = UIFont.systemFont(ofSize: size)
    }
    
    public func alpaOffset(_ offset: CGFloat) {
        
        self.mainNavigationView.alpha = offset
        
        if offset >= 1.0 {
            self.mainNavigationView.addShadow(offset: CGSize(width: 0, height: 2), color: UIColor(hexString: "#ededed"), borderColor: UIColor.clear, radius: 4, opacity: 0.8)
        }  else {
            self.mainNavigationView.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.clear, borderColor: UIColor.clear, radius: 0, opacity: 0.0)
        }
        
        _ = [leftButton, shareButton, cartButton].map {
            $0?.tintColor = UIColor(red: 1 - (offset / 2), green: 1 - (offset / 2), blue: 1 - (offset / 2), alpha: 1)
        }
        
        self.titleLabel.textColor = UIColor(red: 1 - (offset / 2), green: 1 - (offset / 2), blue: 1 - (offset / 2), alpha: 1)
    }
    
}

extension SecondaryNavigationBar: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarLabel.endEditing(true)
    }
}
