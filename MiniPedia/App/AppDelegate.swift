//
//  AppDelegate.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
        
        _ = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: { total in
                    print("Resource count: \(RxSwift.Resources.total).")
                }
            )
        
        
        return true
    }
    
    
}


#if TRACE_RESOURCES
fileprivate var resourceCount: AtomicInt = 0
/// Resource utilization information
public struct Resources {
    /// Counts internal Rx resource allocations (Observables, Observers, Disposables, etc.). This provides a simple way to detect leaks during development.
    public static var total: Int32 {
        return resourceCount.valueSnapshot()
    }
}
#endif
