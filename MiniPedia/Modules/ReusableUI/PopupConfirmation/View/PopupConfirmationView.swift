//
//  PopupConfirmationView.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 17/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import BottomPopup
import RxSwift

protocol ConfirmPopupViewDelegate: class {
    func didItConfirm()
    func didItCancel()
}

enum PopupConfirmType {
    case cartDelete
    case whishlistDelete
}

class PopupConfirmationView: BottomPopupViewController {
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(250) }
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(16) }
    
    override var popupPresentDuration: Double { return presentDuration ?? 0.3 }
    
    override var popupDismissDuration: Double { return dismissDuration ?? 0.3 }
    
    override var popupShouldDismissInteractivelty: Bool { return true }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    unowned var delegate: ConfirmPopupViewDelegate!
    var confirmType: PopupConfirmType = .cartDelete
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame =  CGRect(x: 0, y: 0,
                                  width: UIScreen.main.bounds.width,
                                  height: self.popupHeight)
        bindUI()
    }
    
    private func bindUI() {
        
        btnConfirm.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                self.delegate.didItConfirm()
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        btnCancel.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                self.delegate.didItCancel()
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        if confirmType == .cartDelete {
            self.titleLabel.text = "Hapus ?"
            self.messageLabel.text = "Apakah anda yakin akan menghapus semua barang di keranjang ?"
        } else if confirmType == .whishlistDelete {
            self.titleLabel.text = "Hapus ?"
            self.messageLabel.text = "Apakah anda yakin akan menghapus semua barang di whishlist ?"
        }
        
    }


}
