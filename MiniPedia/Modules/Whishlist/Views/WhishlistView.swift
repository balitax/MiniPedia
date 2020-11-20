//
//  WhishlistView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 20/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import RealmSwift

class WhishlistView: UIViewController {
    
    // MARK: -- VIEW COMPONENTS
    @IBOutlet weak var navigationBar: SecondaryNavigationBar!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint! {
        didSet {
            if let height = self.navigationController?.navigationBar.frame.height {
                self.navigationBarHeight.constant = height + 60
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -- VARIABLES
    let disposeBag = DisposeBag()
    var viewModel: WhishlistViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        
        navigationBar.leftButtonObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] pip in
                self.viewModel.backButtonDidTap.onNext(())
            }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        navigationBar.enableRightButtonItems = false
        navigationBar.title = "Whishlist"
        navigationBar.fontFize(16)
        navigationBar.isLeftButtonHidden = false
        tableView.setEmptyView(stateType: .profile, delegate: self)
    }
    
}

extension WhishlistView: EmptyStateViewDelegate {
    func didTapState() {
        self.showLoading()
        Delay.wait {
            self.hideLoading()
        }
    }
}
