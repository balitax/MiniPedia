//
//  ReactiveCoordinator.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 12/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import RxSwift

open class ReactiveCoordinator<ResultType>: NSObject {
    
    public typealias CoordinatorResult = ResultType
    
    public let disposeBag           = DisposeBag()
    private let identifier          = UUID()
    private var childCoordinators   = [UUID: Any]()
    
    private func store<T>(_ coordinator: ReactiveCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func release<T>(to coordinator: ReactiveCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    @discardableResult
    open func coordinate<T>(to coordinator: ReactiveCoordinator<T>) -> Observable<T> {
        store(coordinator)
        return coordinator.start()
            .do(onNext:  { [weak self] _ in
                self?.release(to: coordinator) })

    }
    
    open func start() -> Observable<ResultType> {
        fatalError("start() method must be implemented")
    }
    
}
