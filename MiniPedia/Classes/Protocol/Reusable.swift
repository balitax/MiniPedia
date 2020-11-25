//
//  Reusable.swift
//  MiniPedia
//
//  Created by Agus Cahyono on 08/09/20.
//

import Foundation
import UIKit

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib? { return UINib(nibName: String(describing: self), bundle: nil) }
}
