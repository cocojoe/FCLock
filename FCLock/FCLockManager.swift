//
//  FCLockManager.swift
//  FCLock
//
//  Created by Martin Walsh on 30/09/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit
import SwiftyJSON

public typealias FCLockHandler = () -> (Void)

struct Auth0 {
    var client_id:String?
    var domain:String?
}

public enum SocialAuth {
    case facebook, google
}

public class FCLockManager {
    
    public static let sharedInstance = FCLockManager()
    
    let network:FCLockNetwork!
    let authController:FCLockController!
    var client = Auth0()
    var XSRF:String?
    var URLScheme:String?
    
    public var onAuthentication:FCLockHandler = {}
    
    public var isAuthenticated:Bool {
        if let _ = network.token.access {
            return true
        }
        return false
    }
    
    private init() {
        
        // Check Auth0 credentials provided
        guard let client_id = Bundle.main.object(forInfoDictionaryKey: "Auth0ClientId"),
            let domain = Bundle.main.object(forInfoDictionaryKey: "Auth0Domain") else {
                fatalError("Check Auth0 credentials (Auth0ClientId, Auth0Domain) set in Info.plist")
        }
        
        client.client_id = client_id as! String
        client.domain = domain as! String
        
        URLScheme = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
  
        // Setup networking
        network = FCLockNetwork()
        
        // Ensure access to resource bundle in FCLock
        let lockBundle = Bundle(for: FCLockController.self)
        
        // Setup login controller
        authController = FCLockController(nibName: "FCLockController", bundle: lockBundle)
        authController.modalPresentationStyle = .overFullScreen
    }
    
    public func applySkin(skin: FCLockSkin) {
        authController.applySkin(skin: skin)
    }
    
    public func presentLogin(fromController: UIViewController) {
        fromController.present(authController, animated: true, completion: nil)
    }
    
    func authenticate(username: String, password: String, onError: @escaping FCLockHandler) {
        network.authenticate(username: username, password: password) { (success) in
            if success == true {
                self.authController.dismiss(animated: true, completion: nil)
                self.onAuthentication()
            } else {
                onError()
            }
        }
    }
    
    
    public func authenticate(social url: URL) {
        
        // Replace # so components can parse query string
        let replaceURL = url.absoluteString.replacingOccurrences(of: "#", with: "?")
        let components = URLComponents(string: replaceURL)
        
        // Extract important information
        let queryItems  = components?.queryItems
        let tokenAccess = queryItems?.filter { (item) in item.name == "access_token" }.first?.value!
        let tokenType = queryItems?.filter { (item) in item.name == "token_type" }.first?.value!
        let tokenXSRF = queryItems?.filter { (item) in item.name == "state" }.first?.value!
        
        guard let accessValue = tokenAccess, let typeValue = tokenType, let xsrf = tokenXSRF else {
            authController.dismissWebView()
            return
        }
        
        if xsrf != XSRF {
            print("XSRF Not Matching")
            authController.dismissWebView()
            return
        }
        
        network.token.access = accessValue
        network.token.type = typeValue
        
        self.authController.dismiss(animated: true, completion: nil)
        self.onAuthentication()
        
    }
    
    func requestPasscode(username: String, onError: @escaping FCLockHandler) {
        network.requestPasscode(username: username) { (success) in
            if success == true {
                self.onAuthentication()
            } else {
                onError()
            }
        }
    }
    
    func generateXSRF() -> String {
        XSRF = randomString(length: 12)
        return XSRF!
    }
    
    
}
