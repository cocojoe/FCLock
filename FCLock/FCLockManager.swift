//
//  FCLockManager.swift
//  FCLock
//
//  Created by Martin Walsh on 30/09/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit

public typealias FCLockHandler = () -> (Void)

public class FCLockManager {
    
    public static let sharedInstance = FCLockManager()
    
    let network:FCLockNetwork!
    let authController:FCLockController!
    
    public var onAuthentication:FCLockHandler = {}
    
    public var isAuthenticated:Bool {
        if network.token.type.characters.count > 0 && network.token.id.characters.count > 0
            && network.token.access.characters.count > 0 {
            return true
        }
        return false
    }
    
    private init() {
        
        // Setup networking
        network = FCLockNetwork()
        
        // Ensure access to resource bundle in FCLock
        let lockBundle = Bundle(for: FCLockController.self)
        
        // Setup login controller
        authController = FCLockController(nibName: "FCLockController", bundle: lockBundle)
        authController.modalPresentationStyle = .popover
    }
    
    public func applySkin(skin: FCLockSkin) {
        authController.applySkin(skin: skin)
    }
    
    public func presentLogin(fromController: UIViewController) {
        fromController.present(authController, animated: true, completion: nil)
    }
    
    func authenticate(username: String, password: String, onError: @escaping FCLockHandler) {
        network.login(username: username, password: password) { (success) in
            if success == true {
                self.authController.dismiss(animated: true, completion: nil)
                self.onAuthentication()
            } else {
                onError()
            }
        }
    }
}
