//
//  NSMutableAttributedString+Extension.swift
//  MiniPedia
//
//  Created by Agus RoomMe on 13/10/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    func bold(_ value:String, fontSize: CGFloat = 14) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: fontSize)
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String, fontSize: CGFloat = 14) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: fontSize),
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String, fontSize: CGFloat = 14) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  UIFont.systemFont(ofSize: fontSize),
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String, fontSize: CGFloat = 14) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: fontSize),
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String, fontSize: CGFloat = 14) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: fontSize),
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
