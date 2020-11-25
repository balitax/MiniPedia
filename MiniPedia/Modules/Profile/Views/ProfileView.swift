//
//  ProfileView.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 20/11/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

class ProfileView: UIViewController, EmptyStateViewDelegate {
    
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
    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }

    private func bindViewModel() {
        navigationBar.enableRightButtonItems = false
        navigationBar.title = "Profile"
        navigationBar.fontFize(20)
        navigationBar.isEnableShadow = false
        navigationBar.alpaOffset(1)
        navigationBar.isLeftButtonHidden = true
        tableView.setEmptyView(stateType: .profile, delegate: self)
    }
    
    func didTapState() {
        self.showLoading()
        Delay.wait {
            self.hideLoading()
        }
    }

}
