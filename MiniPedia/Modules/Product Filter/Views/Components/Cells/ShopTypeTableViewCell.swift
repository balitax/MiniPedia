//
//  ShopTypeTableViewCell.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 08/09/20.
//

import UIKit

protocol ShopTypeTableViewDelegate: class {
    func didSelectShopType()
    func didDeleteMerchantTypeSelected(_ shopType: [ShopTypeModel])
}


class ShopTypeTableViewCell: UITableViewCell {
    
    weak var delegate: ShopTypeTableViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var shopType = [ShopTypeModel]() {
        didSet {
            if self.shopType.isEmpty {
                self.collectionView.isHidden = true
            } else {
                self.collectionView.isHidden = false
            }
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        componentCollectionView()
    }
    
    func componentCollectionView() {
        self.collectionView.register(ShopTyleListCollectionViewCell.nib(), forCellWithReuseIdentifier: ShopTyleListCollectionViewCell.idenfier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let tagCellLayout = TagCellLayout(alignment: .left, delegate: self)
        self.collectionView.collectionViewLayout = tagCellLayout
        self.collectionView.reloadData()
        self.collectionViewHeight.constant = self.collectionView.contentSize.height
        self.collectionView.layoutIfNeeded()
    }
    
    @IBAction func didTapSelectShopType(_ sender: UIButton) {
        self.delegate?.didSelectShopType()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ShopTypeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, ShopTyleListCollectionViewDelegate {
    
    //MARK: - UICollectionView Delegate/Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopTyleListCollectionViewCell.idenfier, for: indexPath) as! ShopTyleListCollectionViewCell
        
        cell.shopType.text = self.shopType[indexPath.row].typeName
        cell.tags = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shopType.count
    }
    
    func didDeleteShopType(_ index: Int) {
        self.shopType.remove(at: index)
        self.collectionView.reloadData()
        self.delegate?.didDeleteMerchantTypeSelected(self.shopType)
    }
    
}

extension ShopTypeTableViewCell: TagCellLayoutDelegate {
    
    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
        let size = ShopTypeModel.mock()[index]
        let getSize = textSize(text: size.typeName, font: UIFont.systemFont(ofSize: 14), collectionView: self.collectionView)
        return CGSize(width: getSize.width + 90, height: 60)
    }
    
    func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {
        var f = collectionView.bounds
        f.size.height = 9999.0
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = font
        let s = label.sizeThatFits(f.size)
        return s
    }
    
}

extension ShopTypeTableViewCell: Reusable { }

