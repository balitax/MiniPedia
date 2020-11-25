//
//  Realm+Transaction.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 14/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm

public final class WriteTransaction {
    private let realm: Realm
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func add<T: Persistable>(_ value: T, update: Realm.UpdatePolicy) {
        realm.add(value.managedObject(), update: update)
    }
}

// Implement the Container
public final class RealmContainer {
    private let realm: Realm
    public convenience init() throws {
        try self.init(realm: Realm())
    }
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func write(_ block: (WriteTransaction) throws -> Void)
    throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
        }
    }
}
