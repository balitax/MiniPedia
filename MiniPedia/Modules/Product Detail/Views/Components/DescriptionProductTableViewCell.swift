//
//  DescriptionProductTableViewCell.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

protocol DescriptionProductDelegate: NSObject {
    func didReadmoreDescription(_ readmore: Bool)
}

class DescriptionProductTableViewCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var btnReadMore: UIButton!
    
    var isReadmore = false
    weak var delegate: DescriptionProductDelegate?
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.descriptionLabel.numberOfLines = 6
        self.btnReadMore.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.didReadMoreDescription()
            }).disposed(by: disposeBag)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func didReadMoreDescription() {
        self.isReadmore.toggle()
        if self.isReadmore {
            self.descriptionLabel.numberOfLines = 0
            self.btnReadMore.setTitle("Baca Lebih Sedikit", for: .normal)
        } else {
            self.descriptionLabel.numberOfLines = 6
            self.btnReadMore.setTitle("Baca Selengkapnya", for: .normal)
        }
        self.delegate?.didReadmoreDescription(isReadmore)
    }
    
    func configureCell() {
        let desc = """
        Deskripsi Laptop Hp Ultrabook folio 9480m - corei5 4310U - ram 8GB - HDD 500GB
        Laptop Hp Ultrabook folio 9480m (slim)..

        spek:
        - proc corei5 4310U 2.2Ghz Up to 2.6Ghz
        - Ram 8GB DDR3L
        - HDD 500GB
        - cam
        - wifi
        - VGA Intel HD
        - keyboard backlight ( nyala )
        - port usb 3.0
        - port LAN
        - Layar 14" wide led
        - Windows 7 pro siap pakai

        kelengkapan:
        - laptop
        - charger
        - tas

        kondisi barang:
        + 90% MULUS sisa nya bekas pemakaian
        + baterai Normal (2 - 3 jam)
        + 100% Original Branded HP
        + Belum pernah di Service
        + Semua berfungsi normal
        + No error running windows

        NB: Garansi personal.

        * Jabodetabek bisa gosend
        *Untuk Jarak jauh bisa dikirim dengan packingan aman. (bubblewrap dan kardus).

        ayo di order ..STOCK Terbatas..

        Reseller..ecer..grosir..WELCOME..

        Jangan ragu untuk bertanya atau order.

        Terima kasih.

        WA: 085214918877
        """
        
        self.descriptionLabel.text = desc
    }
    
}
