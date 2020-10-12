//
//  StoryboardLoadable.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 08/09/20.
//

import Foundation
import UIKit

protocol StoryboardLoadable {
    static func storyboardName() -> String
    static func storyboardIdentifier() -> String
}

extension StoryboardLoadable where Self: UIViewController {
    static func storyboardName() -> String {
        return String(describing: Self.self).replacingOccurrences(of: "ViewController", with: "")
    }
    
    static func storyboardIdentifier() -> String {
        return String(describing: Self.self)
    }
}

extension StoryboardLoadable where Self: UITableViewController {
    static func storyboardName() -> String {
        return String(describing: Self.self).replacingOccurrences(of: "TableViewController", with: "")
    }
    
    static func storyboardIdentifier() -> String {
        return String(describing: Self.self)
    }
}


extension UIStoryboard {
    static func loadViewController<T>() -> T where T: StoryboardLoadable, T: UIViewController {
        return UIStoryboard(name: T.storyboardName(), bundle: nil).instantiateViewController(withIdentifier: T.storyboardIdentifier()) as! T
    }
}
