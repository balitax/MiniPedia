//
//  Refreshable.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@objc protocol Refreshable
{
    /// The refresh control
    var refreshControl: UIRefreshControl? { get set }
    
    /// The table view
    var listView: UIScrollView! { get set }
    
    /// the function to call when the user pulls down to refresh
    @objc func handleRefresh(_ sender: Any);
}


extension Refreshable where Self: UIViewController
{
    func installRefreshControl()
    {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
        
        if #available(iOS 10.0, *)
        {
            listView.refreshControl = refreshControl
        }
        else
        {
            listView.addSubview(refreshControl)
        }
    }
}

class RefreshHandler: NSObject {
    
    let refresh = PublishSubject<Void>()
    let refreshControl = UIRefreshControl()
    
    init(view: UIScrollView) {
        super.init()
        view.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh(_: )), for: .valueChanged)
    }
    
    // MARK: - Action
    @objc func refreshControlDidRefresh(_ control: UIRefreshControl) {
        refresh.onNext(())
    }
    
    func end() {
        refreshControl.endRefreshing()
    }
}
