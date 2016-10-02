//
//  FCLockExtensions.swift
//  FCLock
//
//  Created by Martin Walsh on 01/10/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit

extension UIView {
    
    func scalePop() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            }, completion: {(finished: Bool) -> Void in
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: nil)
                
        })
        
    }
    
    func showError() {
        self.layer.borderWidth = 1.0
        self.scalePop()
    }
    
    func hideError() {
        self.layer.borderWidth = 0
    }
}

extension UIButton {
    
    func disableButton() {
        self.layer.opacity = 0.5
        self.isEnabled = false
    }
    
    func enableButton() {
        self.layer.opacity = 1.0
        self.isEnabled = true
    }
    
}
