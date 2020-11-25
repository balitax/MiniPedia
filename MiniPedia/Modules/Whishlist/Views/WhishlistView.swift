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
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: -- VARIABLES
    let disposeBag = DisposeBag()
    var viewModel: WhishlistViewModel!
    private var isSearchBarActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        
        viewModel.getWhishlistData()
        
        viewModel.state
            .asObserver()
            .subscribe(onNext: { [unowned self] state in
                if state == .finish {
                    self.reloadTableView()
                    self.hideLoading()
                } else {
                    self.showLoading()
                }
            }).disposed(by: disposeBag)
        
        Observable.changeset(from: viewModel.whishlists)
            .subscribe(onNext: { [unowned self] data, changes in
                if let changes = changes {
                    self.tableView.applyChangeset(changes)
                } else {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        navigationBar.leftButtonObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] pip in
                self.viewModel.backButtonDidTap.onNext(())
            }).disposed(by: disposeBag)
        
        searchBar.rx
            .text
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                guard let text = text else { return }
                self.viewModel.searchWhishlist(by: text)
            }).disposed(by: disposeBag)
        
        viewModel.onSearchWhishlist
            .subscribe(onNext: { [unowned self] _ in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        navigationBar.enableRightButtonItems = false
        navigationBar.title = "Whishlist"
        navigationBar.fontFize(16)
        navigationBar.isEnableShadow = false
        navigationBar.alpaOffset(1)
        navigationBar.isLeftButtonHidden = false
        
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        self.tableView.registerReusableCell(WhishlistItemsViewCell.self)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .systemGroupedBackground
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        self.tableView.separatorStyle = .none
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableView.tableHeaderView = UIView(frame: frame)
        self.tableView.tableFooterView = UIView(frame: frame)
    }
    
}

extension WhishlistView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchBarActive {
            if viewModel.whishlistSearch.count == 0 {
                tableView.setEmptyView(stateType: .whishlist, delegate: self)
            }
            else {
                tableView.restore()
            }
            return viewModel.whishlistSearch.count
        } else {
            if viewModel.whishlist.count == 0 {
                tableView.setEmptyView(stateType: .whishlist, delegate: self)
            }
            else {
                tableView.restore()
            }
            return viewModel.whishlist.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WhishlistItemsViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        
        if isSearchBarActive {
            cell.bindingData(viewModel.whishlistSearch[indexPath.row])
        } else {
            cell.bindingData(viewModel.whishlist[indexPath.row])
        }
        
        cell.rows = indexPath.row
        cell.delegate = self
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.getDetailProduct(rows: indexPath.row)
    }
    
}


extension WhishlistView: EmptyStateViewDelegate, WhishlistItemsViewDelegate {
    
    func didRemoveWhishlistItem(rows: Int) {
        viewModel.deleteWhishlist(rows: rows)
    }
    
    func addToCart(rows: Int) {
        viewModel.moveToCart(rows)
    }
    
    func didTapState() {
        self.showLoading()
        Delay.wait {
            self.hideLoading()
        }
    }
}


extension WhishlistView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.isSearchBarActive = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.isSearchBarActive = false
        self.searchBar.endEditing(true)
        viewModel.resetSearch()
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearchBarActive = true
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
}
