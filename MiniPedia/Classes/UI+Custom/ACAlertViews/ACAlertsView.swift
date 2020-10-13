//
//  ACAlertsView.swift
//  ACAlerts
//
//  Created by Agus Cahyono on 14/09/20.
//  Copyright © 2020 Agus Cahyono. All rights reserved.
//

import UIKit

public class ACAlertsView: UIView {
    
    public var marginBottom: CGFloat = 80
    public var marginTop: CGFloat = 50
    
    public var duration = 0.3
    public var delay: Double = 2.0
    
    public var position = AlertPosition.top
    public var direction = AnimationDirection.normal
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    
    private var font = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.titleLabel.font = self.font
        }
    }
    
    private var frameworkBundle:Bundle? {
        let bundleId = "id.agus.ACAlertsView"
        return Bundle(identifier: bundleId)
    }
    
    @IBOutlet weak var alertContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertIcon: UIImageView!
    @IBOutlet weak var alertBorder: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        self.titleLabel.font = self.font
        
        // add shadow to container
        self.alertContainer.addShadow(offset: CGSize(width: 0, height: 2), color: UIColor.grayShadow, borderColor: UIColor.grayShadow, radius: 2, opacity: 0.8)
        
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ACAlertsView", bundle: frameworkBundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    public init(position: AlertPosition = .bottom, direction: AnimationDirection = .normal, marginTop: CGFloat = 50, marginBottom: CGFloat = 80) {
        super.init(frame: CGRect.zero)
        
        commonInit()
        
        self.marginTop = marginTop
        self.marginBottom = marginBottom
        
        self.frame = getFrameBy(position, direction: direction)
        self.direction = direction
        self.position = position
    }
    
    public func show(_ message: String, style: AlertStyle, font: UIFont = UIFont.systemFont(ofSize: 14), direction: AnimationDirection = .toRight, delay: Double = 2.0) {
        
        addWindowSubview(self)
        configureProperties(message, style: style)
        
        self.delay = delay
        self.font = font
        
        UIView.animate(withDuration: self.duration, animations: {
            
            switch self.direction {
            case .toRight:
                self.frame.origin.x = 0
            case .toLeft:
                self.frame.origin.x = 0
            case .normal:
                self.frame.origin.y = self.position == .top ? 0 : self.screenHeight-self.marginBottom
            }
        })
        perform(#selector(hide), with: self, afterDelay: self.delay)
    }
    
    @objc private func hide(_ alertView: UIButton) {
        
        UIView.animate(withDuration: duration, animations: {
            
            switch self.direction {
            case .toRight:
                self.frame.origin.x = -self.screenWidth
            case .toLeft:
                self.frame.origin.x = self.screenWidth
            case .normal:
                (self.position == .top) ? (alertView.frame.origin.y = -self.marginBottom) : (alertView.frame.origin.y = self.screenHeight)
            }
        })
        
        perform(#selector(remove), with: alertView, afterDelay: delay)
    }
    
    
    @objc private func remove(_ alertView: UIButton) {
        alertView.removeFromSuperview()
    }
    
    private func configureProperties(_ message: String, style: AlertStyle) {
        
        self.titleLabel.text = message
        
        switch style {
        case .success:
            self.alertContainer.backgroundColor = .greenIce
            self.alertBorder.backgroundColor = .lightGreen
            self.alertIcon.image = UIImage(named: "success_icon", in: frameworkBundle, compatibleWith: nil)
        case .error:
            self.alertContainer.backgroundColor = .lightPink
            self.alertBorder.backgroundColor = .redCoral
            self.alertIcon.image = UIImage(named: "error_icon", in: frameworkBundle, compatibleWith: nil)
        case .info:
            self.alertContainer.backgroundColor = .iceBlue
            self.alertBorder.backgroundColor = .darkBlue
            self.alertIcon.image = UIImage(named: "info_icon", in: frameworkBundle, compatibleWith: nil)
        case .warning:
            self.alertContainer.backgroundColor = .iceBlue
            self.alertBorder.backgroundColor = .goldenYellow
            self.alertIcon.image = UIImage(named: "warning_icon", in: frameworkBundle, compatibleWith: nil)
        }
        
    }
    
    // MARK: -- FRAME SETUP
    private func getFrameBy(_ position: AlertPosition, direction: AnimationDirection) -> CGRect {
        let frame: CGRect
        
        switch position {
        case .top:
            frame = getFrameOfTopPositionBy(direction)
        case .bottom:
            frame = getFrameOfBottomPositionBy(direction)
        }
        
        return frame
    }
    
    private func getFrameOfTopPositionBy(_ direction: AnimationDirection) -> CGRect {
        
        let frame: CGRect
        
        switch direction {
        case .toRight:
            frame = CGRect(x: -screenWidth, y: self.safeAreaInsets.top + self.marginTop, width: screenWidth, height: marginTop)
        case .toLeft:
            frame = CGRect(x: screenWidth, y: self.safeAreaInsets.top + self.marginTop, width: screenWidth, height: marginTop)
        case .normal:
            frame = CGRect(x: 0.0, y: self.safeAreaInsets.top + self.marginTop, width: screenWidth, height: marginTop)
        }
        return frame
    }
    
    private func getFrameOfBottomPositionBy(_ direction: AnimationDirection) -> CGRect {
        let frame: CGRect
        switch direction {
        case .toRight:
            frame = CGRect(x: -screenWidth, y: screenHeight - marginBottom, width: screenWidth, height: marginBottom)
        case .toLeft:
            frame = CGRect(x: screenWidth, y: screenHeight - marginBottom, width: screenWidth, height: marginBottom)
        case .normal:
            frame = CGRect(x: 0.0, y: screenHeight + marginBottom, width: screenWidth, height: marginBottom)
        }
        return frame
    }
    
    
}
