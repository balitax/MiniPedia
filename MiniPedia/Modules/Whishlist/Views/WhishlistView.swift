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
        setupTableView()
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
        navigationBar.isEnableShadow = false
        navigationBar.isLeftButtonHidden = false
        tableView.setEmptyView(stateType: .profile, delegate: self)
    }
    
    private func setupTableView() {
        self.tableView.registerReusableCell(WhishlistItemsViewCell.self)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .systemGroupedBackground
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.separatorStyle = .none
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.tableView.tableFooterView = UIView(frame: frame)
//        
//        self.view.showAnimatedSkeleton()
    }
    
}

extension WhishlistView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WhishlistItemsViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
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
