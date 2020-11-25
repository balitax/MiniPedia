//
//  EmptyStateView.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 17/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

enum EmptyStateType {
    case cart
    case whishlist
    case profile
}

protocol EmptyStateViewDelegate: class {
    func didTapState()
}

class EmptyStateView: UIView {
    
    private static let NIB_NAME = "EmptyStateView"
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imgIconState: UIImageView!
    @IBOutlet weak var titleState: UILabel!
    @IBOutlet weak var messageState: UILabel!
    @IBOutlet weak var btnState: UIButton!
    
    var stateType = EmptyStateType.cart {
        didSet {
            self.bindUI()
        }
    }
    unowned var delegate: EmptyStateViewDelegate?
    
    private var disposeBag = DisposeBag()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
        
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    fileprivate func bindUI () {
        
        btnState.rx
            .tap
            .subscribe(onNext: { [unowned self] _ in
                self.delegate?.didTapState()
            }).disposed(by: self.disposeBag)
        
        if stateType == .cart {
            self.imgIconState.image = #imageLiteral(resourceName: "empty_state_icon")
            self.titleState.text = "Wah, keranjang belanjamu kosong"
            self.messageState.text = "Daripada dianggurin, mending isi dengan barang-barang impianmu. Yuk, cek sekarang!"
            self.btnState.setTitle("Mulai Belanja", for: .normal)
        } else if stateType == .profile {
            self.imgIconState.image = #imageLiteral(resourceName: "empty_state_icon")
            self.titleState.text = "Oops, Terjadi kesalahan saat mendapatkan data profil kamu"
            self.messageState.text = "Coba lagi nanti, mungkin kamu butuh istirahat dan liburan, jangan belanja terus!"
            self.btnState.setTitle("Coba Lagi", for: .normal)
        } else {
            self.imgIconState.image = #imageLiteral(resourceName: "empty_state_icon")
            self.titleState.text = "Wah, whishlist kamu kosong"
            self.messageState.text = "Daripada dianggurin, mending isi dengan barang-barang impianmu. Yuk, cek sekarang!"
            self.btnState.setTitle("Belanja Sekarang", for: .normal)
        }
    }
    
}
